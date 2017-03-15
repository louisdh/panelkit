//
//  PanelViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 24/11/2016.
//  Copyright © 2016-2017 Silver Fox. All rights reserved.
//

import UIKit

@objc public class PanelViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

	weak var topConstraint: NSLayoutConstraint?
	weak var bottomConstraint: NSLayoutConstraint?

	weak var leadingConstraint: NSLayoutConstraint?
	weak var trailingConstraint: NSLayoutConstraint?

	weak var widthConstraint: NSLayoutConstraint?
	weak var heightConstraint: NSLayoutConstraint?

	var panelPinnedPreviewView: UIView?

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

	// MARK: -

	public init(with contentViewController: UIViewController, contentDelegate: PanelContentDelegate, in panelManager: PanelManager) {

		self.contentDelegate = contentDelegate
		self.contentViewController = contentViewController

		self.panelNavigationController = PanelNavigationController(rootViewController: contentViewController)
		panelNavigationController.view.translatesAutoresizingMaskIntoConstraints = false

		self.shadowView = UIView(frame: .zero)

		super.init(nibName: nil, bundle: nil)

		self.view.addSubview(shadowView)
		self.addChildViewController(panelNavigationController)
		self.view.addSubview(panelNavigationController.view)
		panelNavigationController.didMove(toParentViewController: self)

		panelNavigationController.panelViewController = self

		panelNavigationController.navigationBar.tintColor = contentViewController.view.tintColor

		self.view.clipsToBounds = false

		panelNavigationController.view.layer.cornerRadius = cornerRadius
		panelNavigationController.view.clipsToBounds = true

		panelNavigationController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
		panelNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
		panelNavigationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		panelNavigationController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

		self.delegate = panelManager

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_ :)))
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)

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

		shadowView.frame = panelNavigationController.view.frame

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

	func didTap(_ sender: UITapGestureRecognizer) {

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
