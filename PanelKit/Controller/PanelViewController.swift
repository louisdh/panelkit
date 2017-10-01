//
//  PanelViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 24/11/2016.
//  Copyright © 2016-2017 Silver Fox. All rights reserved.
//

import UIKit

struct HandleContainer {
	
	let wrapperView: UIView
	let handleView: HandleView
	
}

@objc public class PanelViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

	weak var topConstraint: NSLayoutConstraint?
	weak var bottomConstraint: NSLayoutConstraint?

	weak var leadingConstraint: NSLayoutConstraint?
	weak var trailingConstraint: NSLayoutConstraint?

	weak var widthConstraint: NSLayoutConstraint?
	weak var heightConstraint: NSLayoutConstraint?

	var panelPinnedPreviewView: UIView?

	var dragGestureRecognizer: UIPanGestureRecognizer?

	var scaleStartFrame: CGRect?

	fileprivate var prevTouch: CGPoint?

	var position: CGPoint?
	var positionInFullscreen: CGPoint?

	/// Shadow "force" disabled (meaning not by delegate choice).
	///
	/// E.g. when panel is pinned.
	var isShadowForceDisabled = false

	// TODO: make internal?
	@objc public let panelNavigationController: PanelNavigationController

	@objc public weak var contentViewController: UIViewController?

	var pinnedSide: PanelPinSide?

	var frameBeforeExpose: CGRect? {
		didSet {
			if isInExpose {
				panelNavigationController.view.endEditing(true)
				panelNavigationController.view.isUserInteractionEnabled = false
			} else {
				panelNavigationController.view.isUserInteractionEnabled = true
			}
		}
	}

	var logLevel: LogLevel {
		return delegate?.panelManagerLogLevel ?? .none
	}

	weak var delegate: PanelManager? {
		didSet {
			self.updateShadow()
		}
	}

	weak var contentDelegate: PanelContentDelegate?

	let shadowView: UIView

	let leftHandleContainer: HandleContainer
	let rightHandleContainer: HandleContainer
	let topHandleContainer: HandleContainer
	let bottomHandleContainer: HandleContainer
	
	let horizontalStackView = UIStackView()

	// MARK: -

	public init(with contentViewController: UIViewController, contentDelegate: PanelContentDelegate, in panelManager: PanelManager) {

		self.contentDelegate = contentDelegate
		self.contentViewController = contentViewController

		self.panelNavigationController = PanelNavigationController(rootViewController: contentViewController)
		panelNavigationController.view.translatesAutoresizingMaskIntoConstraints = false

		self.shadowView = UIView(frame: .zero)
		shadowView.translatesAutoresizingMaskIntoConstraints = false

		leftHandleContainer = PanelViewController.handleContainer(for: .vertical)
		rightHandleContainer = PanelViewController.handleContainer(for: .vertical)
		
		topHandleContainer = PanelViewController.handleContainer(for: .horizontal)
		bottomHandleContainer = PanelViewController.handleContainer(for: .horizontal)
		

		
		super.init(nibName: nil, bundle: nil)
		
		
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enterResizing(_:)))
		
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		doubleTapGestureRecognizer.numberOfTouchesRequired = 2
		
		self.view.addGestureRecognizer(doubleTapGestureRecognizer)
		
		
	
		
		let leftHandlePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragLeftHandle(_:)))
		
		leftHandleContainer.handleView.addGestureRecognizer(leftHandlePanGestureRecognizer)

		let rightHandlePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragRightHandle(_:)))
		
		rightHandleContainer.handleView.addGestureRecognizer(rightHandlePanGestureRecognizer)
	
		let topHandlePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragTopHandle(_:)))
		
		topHandleContainer.handleView.addGestureRecognizer(topHandlePanGestureRecognizer)
		
		let bottomHandlePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragBottomHandle(_:)))
		
		bottomHandleContainer.handleView.addGestureRecognizer(bottomHandlePanGestureRecognizer)
		
		
		let pinchToResizeGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchToResize(_:)))

		self.view.addGestureRecognizer(pinchToResizeGestureRecognizer)

		
		let verticalStackView = UIStackView()
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false
	
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(shadowView)
		self.addChildViewController(panelNavigationController)
		self.view.addSubview(panelNavigationController.view)
		self.view.addSubview(horizontalStackView)
		panelNavigationController.didMove(toParentViewController: self)

		panelNavigationController.panelViewController = self

		panelNavigationController.navigationBar.tintColor = contentViewController.view.tintColor

		self.view.clipsToBounds = false

		panelNavigationController.view.layer.cornerRadius = cornerRadius
		panelNavigationController.view.clipsToBounds = true
		
		panelNavigationController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).isActive = true
		panelNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
		panelNavigationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		panelNavigationController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

		
		
		horizontalStackView.distribution = .fill
		horizontalStackView.axis = .horizontal
		horizontalStackView.alignment = .fill
		horizontalStackView.spacing = 4.0



		horizontalStackView.addArrangedSubview(leftHandleContainer.wrapperView)
		horizontalStackView.addArrangedSubview(verticalStackView)
		horizontalStackView.addArrangedSubview(rightHandleContainer.wrapperView)

		verticalStackView.distribution = .fill
		verticalStackView.axis = .vertical
		verticalStackView.alignment = .fill
		
		horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		horizontalStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		horizontalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		// Vibrancy Effect
		let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
		
		let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
		vibrancyEffectView.frame = view.bounds
		
		vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		vibrantLabel.translatesAutoresizingMaskIntoConstraints = false
		
		// Label for vibrant text
		vibrantLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
		vibrantLabel.textAlignment = .center
		
		vibrancyEffectView.contentView.addSubview(vibrantLabel)

		
		verticalStackView.addArrangedSubview(topHandleContainer.wrapperView)
		
		let emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		
		verticalStackView.addArrangedSubview(emptyView)
		
//		emptyView.isUserInteractionEnabled = false

		verticalStackView.addArrangedSubview(bottomHandleContainer.wrapperView)
		
		verticalStackView.spacing = 4.0
		
		self.delegate = panelManager

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_ :)))
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)

		
		
		shadowView.heightAnchor.constraint(equalTo: panelNavigationController.view.heightAnchor, multiplier: 1.0).isActive = true
		shadowView.widthAnchor.constraint(equalTo: panelNavigationController.view.widthAnchor, multiplier: 1.0).isActive = true
		shadowView.leftAnchor.constraint(equalTo: panelNavigationController.view.leftAnchor).isActive = true
		shadowView.topAnchor.constraint(equalTo: panelNavigationController.view.topAnchor).isActive = true
		
		
		
		resizingEffectView.translatesAutoresizingMaskIntoConstraints = false
		resizingEffectView.isUserInteractionEnabled = false
		
//		self.view.addSubview(resizingEffectView)
		self.panelNavigationController.view.addSubview(resizingEffectView)

		resizingEffectView.heightAnchor.constraint(equalTo: panelNavigationController.view.heightAnchor, multiplier: 1.0).isActive = true
		resizingEffectView.widthAnchor.constraint(equalTo: panelNavigationController.view.widthAnchor, multiplier: 1.0).isActive = true
		resizingEffectView.leftAnchor.constraint(equalTo: panelNavigationController.view.leftAnchor).isActive = true
		resizingEffectView.topAnchor.constraint(equalTo: panelNavigationController.view.topAnchor).isActive = true
	
	

		resizingEffectView.contentView.addSubview(vibrancyEffectView)

		vibrancyEffectView.heightAnchor.constraint(equalTo: resizingEffectView.heightAnchor, multiplier: 1.0).isActive = true
		vibrancyEffectView.widthAnchor.constraint(equalTo: resizingEffectView.widthAnchor, multiplier: 1.0).isActive = true
		vibrancyEffectView.leftAnchor.constraint(equalTo: resizingEffectView.leftAnchor).isActive = true
		vibrancyEffectView.topAnchor.constraint(equalTo: resizingEffectView.topAnchor).isActive = true
		

	
		
	
		vibrantLabel.heightAnchor.constraint(equalTo: vibrancyEffectView.heightAnchor, multiplier: 1.0).isActive = true
		vibrantLabel.widthAnchor.constraint(equalTo: vibrancyEffectView.widthAnchor, multiplier: 1.0).isActive = true
		vibrantLabel.leftAnchor.constraint(equalTo: vibrancyEffectView.leftAnchor).isActive = true
		vibrantLabel.topAnchor.constraint(equalTo: vibrancyEffectView.topAnchor).isActive = true
		
		// Add the vibrancy view to the blur view
		
		horizontalStackView.alpha = 0
		
		let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragView(_ :)))
		dragGestureRecognizer.delegate = self
		
		self.view.addGestureRecognizer(dragGestureRecognizer)
		self.dragGestureRecognizer = dragGestureRecognizer
	}
	
	let vibrantLabel = UILabel()
	let resizingEffectView = UIVisualEffectView(effect: nil)

	var isResizing = false
	
	@objc func enterResizing(_ recognizer: UITapGestureRecognizer) {
		
		vibrantLabel.text = panelNavigationController.title

		if isResizing {
			
			isResizing = false
			
			self.resizingEffectView.isUserInteractionEnabled = false

			UIView.animate(withDuration: 0.25) {
				
				self.resizingEffectView.effect = nil
				self.vibrantLabel.alpha = 0
				self.horizontalStackView.alpha = 0
				self.horizontalStackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
			}
			
		} else {
			
			self.horizontalStackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

			isResizing = true
			
			self.resizingEffectView.isUserInteractionEnabled = true
			
			UIView.animate(withDuration: 0.25) {
				
				self.resizingEffectView.effect = UIBlurEffect(style: .dark)
				self.vibrantLabel.alpha = 1
				self.horizontalStackView.alpha = 1
				self.horizontalStackView.transform = .identity

			}
			
		}
		
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

		self.view.translatesAutoresizingMaskIntoConstraints = false

		self.updateShadow()

		if logLevel == .full {
			print("\(self) viewDidLoad")
		}

		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillChangeFrame, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_ :)), name: .UIKeyboardWillHide, object: nil)

    }

	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		didUpdateFloatingState()
		contentViewController?.viewWillAppear(animated)

		contentDelegate?.didUpdateFloatingState()
		contentDelegate?.updateNavigationButtons()

		if logLevel == .full {
			print("\(self) viewWillAppear")
		}

	}

	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		didUpdateFloatingState()
		contentViewController?.viewDidAppear(animated)

		if logLevel == .full {
			print("\(self) viewDidAppear")
		}

	}
	
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		contentViewController?.viewWillDisappear(animated)
		
		if logLevel == .full {
			print("\(self) viewWillDisappear")
		}
		
	}
	
	override public func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		contentViewController?.viewDidDisappear(animated)
		
		if logLevel == .full {
			print("\(self) viewDidDisappear")
		}
		
	}

	override public func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

	}

	override public func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

//		let shadowFrame = panelNavigationController.view.convert(panelNavigationController.view.bounds, to: self.view)
//		
//		shadowView.frame = shadowFrame

		if shadowEnabled {
			shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius).cgPath
		}

	}

	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		updateState()

		coordinator.animate(alongsideTransition: { (context) in

		}) { (context) in

			self.updateState()

		}

	}

	// MARK: -

	@objc func didTap(_ sender: UITapGestureRecognizer) {

		if delegate?.isInExpose == true {

			if !isPinned {
				bringToFront()
			}

			delegate?.exitExpose()
		}

	}

	// MARK: -

	func bringToFront() {

		guard let viewToMove = self.view else {
			return
		}

		guard let superview = viewToMove.superview else {
			return
		}

		superview.bringSubview(toFront: viewToMove)

	}

	// MARK: -

	@objc override public var preferredContentSize: CGSize {
		get {
			return contentDelegate?.preferredPanelContentSize ?? super.preferredContentSize
		}
		set {
			super.preferredContentSize = newValue
		}
	}

	// MARK: -

	func allowedCenter(for proposedCenter: CGPoint) -> CGPoint {

		guard let viewToMove = self.view else {
			return proposedCenter
		}

		guard let superview = viewToMove.superview else {
			return proposedCenter
		}

		var dragInsets = panelNavigationController.dragInsets

		if isPinned {
			// Allow pinned panels to move beyond superview bounds,
			// for smooth transition

			if pinnedSide == .left {
				dragInsets.left -= viewToMove.bounds.width
			}

			if pinnedSide == .right {
				dragInsets.right -= viewToMove.bounds.width
			}

		}

		var newX = proposedCenter.x
		var newY = proposedCenter.y

		newX = max(newX, viewToMove.bounds.size.width/2 + dragInsets.left)
		newX = min(newX, superview.bounds.size.width - viewToMove.bounds.size.width/2 - dragInsets.right)

		newY = max(newY, viewToMove.bounds.size.height/2 + dragInsets.top)
		newY = min(newY, superview.bounds.size.height - viewToMove.bounds.size.height/2 - dragInsets.bottom)

		return CGPoint(x: newX, y: newY)

	}

	deinit {
		if logLevel == .full {
			print("deinit \(self)")
		}
	}

	// MARK: -

	override public var prefersStatusBarHidden: Bool {

		if let contentViewController = contentViewController {
			return contentViewController.prefersStatusBarHidden
		}

		return true
	}

	override public var preferredStatusBarStyle: UIStatusBarStyle {

		if let contentViewController = contentViewController {
			return contentViewController.preferredStatusBarStyle
		}

		return .lightContent
	}

}

extension PanelViewController: UIGestureRecognizerDelegate {
	
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == dragGestureRecognizer {
			return false
		}
		return true
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		
		if gestureRecognizer == dragGestureRecognizer {
			
			// Prevents panel from dragging when sliding UITableViewCell (e.g. for "delete")
			
			// iOS 11
			if type(of: otherGestureRecognizer) == UIPanGestureRecognizer.self && (otherGestureRecognizer.view is UITableView) {
				return true
			}
			
			// iOS 10
			if otherGestureRecognizer is UIPanGestureRecognizer && (otherGestureRecognizer.view?.superview is UITableView) {
				return true
			}
			
			if otherGestureRecognizer.view == self {
				return true
			}
		}
		
		return false
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		
		if gestureRecognizer == dragGestureRecognizer {
			
			if isPresentedAsPopover || isPresentedModally {
				return false
			}
			
			return contentDelegate?.panelDragGestureRecognizer(gestureRecognizer, shouldReceive: touch) ?? true
		}
		
		return true
	}
	
	@objc func dragView(_ gestureRecognizer: UIPanGestureRecognizer) {
		
		if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
			
			prevTouch = nil
			self.didEndDrag()
			return
			
		}
		
		guard isFloating || isPinned else {
			return
		}
		
		guard let viewToMove = self.view else {
			return
		}
		
		guard let superview = viewToMove.superview else {
			return
		}
		
		if gestureRecognizer.numberOfTouches == 0 {
			return
		}
		
		let touch = gestureRecognizer.location(ofTouch: 0, in: superview)
		
		if gestureRecognizer.state == .began {
			
			prevTouch = touch
			
			if self.isPinned != true {
				self.bringToFront()
			}
			
		}
		
		if gestureRecognizer.state == .changed {
			
			guard let prevTouch = prevTouch else {
				self.prevTouch = touch
				return
			}
			
			moveWithTouch(from: prevTouch, to: touch)
		}
		
	}
	
	func moveWithTouch(from fromTouch: CGPoint, to touch: CGPoint) {

		guard let viewToMove = self.view else {
			return
		}
		
		let proposeX = viewToMove.center.x - (fromTouch.x - touch.x)
		let proposeY = viewToMove.center.y - (fromTouch.y - touch.y)
		
		let proposedCenter = CGPoint(x: proposeX, y: proposeY)
		
		var newFrame = viewToMove.frame
		let newCenter = self.allowedCenter(for: proposedCenter)
		newFrame.center = newCenter
		
		self.delegate?.updateFrame(for: self, to: newFrame)
		
		self.prevTouch = touch
		
		self.didDrag(at: touch)
		
	}
	
}
