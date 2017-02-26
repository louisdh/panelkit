//
//  PanelViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 24/11/2016.
//  Copyright © 2016 Silver Fox. All rights reserved.
//

import UIKit

public protocol PanelViewControllerDelegate: class {

	func didDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide)
	func didDragFree(_ panel: PanelViewController)
	
	func didEndDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide)
	func didEndDragFree(_ panel: PanelViewController)
		
	func enablePanelShadow(for panel: PanelViewController) -> Bool
	
}

@objc public class PanelViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

	var topConstraint: NSLayoutConstraint?
	var bottomConstraint: NSLayoutConstraint?

	var leadingConstraint: NSLayoutConstraint?
	var trailingConstraint: NSLayoutConstraint?

	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	
	var panelPinnedPreviewView: UIView?

	
	// TODO: make internal?
	@objc public let panelNavigationController: PanelNavigationController
	
	@objc public weak var contentViewController: PanelContentViewController?
	
	var pinnedSide: PanelPinSide?
	
	public var isPinned: Bool {
		return pinnedSide != nil
	}
	
	public var isFloating: Bool {
		
		guard let contentViewController = contentViewController else {
			return false
		}
		
		return contentViewController.isFloating
	}
	
	public var isInExpose: Bool {
		return frameBeforeExpose != nil
	}
	
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
	
	private let shadowView: UIView

	private let cornerRadius: CGFloat = 16.0
	
	private let shadowRadius: CGFloat = 8.0
	private let shadowOpacity: Float = 0.3
	private let shadowOffset: CGSize = CGSize(width: 0, height: 10.0)
	private let shadowColor =  UIColor.black.cgColor
	
	var tintColor: UIColor {
		return panelNavigationController.navigationBar.tintColor
	}
	
	// MARK: -

	public init(with contentViewController: PanelContentViewController, in panelManager: PanelManager) {
		
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
		
//		self.presentationController?.delegate = self
		
		
		contentViewController.panelDelegate = panelManager
		self.delegate = panelManager
	
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_ :)))
//		tapGestureRecognizer.delegate = self
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
    override public func viewDidLoad() {
        super.viewDidLoad()

		self.view.translatesAutoresizingMaskIntoConstraints = false

		self.updateShadow()

		if logLevel == .full {
			print("\(self) viewDidLoad")
		}
    }
	
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		didUpdateFloatingState()
		contentViewController?.viewWillAppear(animated)

		if logLevel == .full {
			print("\(self) viewWillAppear")
		}
		
	}
	
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		contentViewController?.viewDidAppear(animated)

		if logLevel == .full {
			print("\(self) viewDidAppear")
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

		
		
//		panelNavigationController.setNeedsStatusBarAppearanceUpdate()
//		
//		panelNavigationController.updateViewConstraints()
//
//		panelNavigationController.view.setNeedsLayout()
//		panelNavigationController.view.layoutSubviews()
//		
//		panelNavigationController.navigationBar.setNeedsLayout()
//		panelNavigationController.navigationBar.layoutSubviews()
//		
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
	
	func didUpdateFloatingState() {
		
		updateState()
		
		self.updateShadow()
		
		if !(isFloating || isPinned) {
			widthConstraint?.isActive = false
			heightConstraint?.isActive = false
		}
		
	}
	
	// MARK: -
	
	func didTap(_ sender: UITapGestureRecognizer) {
		
		if delegate?.isInExpose == true {
			
			panelNavigationController.bringToFront()
			
			delegate?.exitExpose()
		}
		
	}
	
	// MARK: -

	func updateState() {
		
		if isFloating || isPinned {
			self.view.translatesAutoresizingMaskIntoConstraints = false
			
			if !isPinned {
				enableCornerRadius()
				if shadowEnabled {
					enableShadow()
				}
			}
			
		} else {
			self.view.translatesAutoresizingMaskIntoConstraints = true
		
			disableShadow()
			disableCornerRadius()
			
		}
		
		contentViewController?.updateNavigationButtons()
		
	}
	
	// MARK: -
	
	@objc override public var preferredContentSize: CGSize {
		get {
			return contentViewController?.preferredPanelContentSize ?? super.preferredContentSize
		}
		set {
			super.preferredContentSize = newValue
		}
	}
	
	// MARK: -
	
	func didDrag() {
		
		guard isFloating || isPinned else {
			return
		}
		
		guard let containerWidth = self.view.superview?.bounds.size.width else {
			return
		}
		
		if self.view.frame.maxX >= containerWidth {
			
			delegate?.didDrag(self, toEdgeOf: .right)
			
		} else if self.view.frame.minX <= 0 {
			
			delegate?.didDrag(self, toEdgeOf: .left)
			
		} else {
			
			delegate?.didDragFree(self)
			
		}
		
	}
	
	func didEndDrag() {
		
		guard isFloating || isPinned else {
			return
		}
		
		guard let containerWidth = self.view.superview?.bounds.size.width else {
			return
		}
		
		if self.view.frame.maxX >= containerWidth {
			
			delegate?.didEndDrag(self, toEdgeOf: .right)
			
		} else if self.view.frame.minX <= 0 {
			
			delegate?.didEndDrag(self, toEdgeOf: .left)
			
		} else {
			
			delegate?.didEndDragFree(self)
			
		}
		
	}
	
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
	
//	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//		return .popover
//	}
//	
//	func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
//		
//		if style == .popover {
//			
//			
//		} else {
//			
//			
//		}
//
//	}
//	
//	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//		return .popover
//	}
//	
//	public func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//		
//		if style == .popover {
//			return self
//		}
//		
//		return panelNavigationController
//		
//	}
	
	// MARK: -
	
	/// Shadow "force" disabled (meaning not by delegate choice).
	///
	/// E.g. when panel is pinned.
	private var isShadowForceDisabled = false

	func disableShadow(animated: Bool = false, duration: Double = 0.3) {
		
		if animated {
			
			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = shadowView.layer.shadowOpacity
			anim.toValue = 0.0
			anim.duration = duration
			shadowView.layer.add(anim, forKey: #keyPath(CALayer.shadowOpacity))
			
		}
		
		shadowView.layer.shadowOpacity = 0.0
		
		isShadowForceDisabled = true
	}
	
	func enableShadow(animated: Bool = false, duration: Double = 0.3) {
		
		if animated {
			
			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = shadowView.layer.shadowOpacity
			anim.toValue = shadowOpacity
			anim.duration = duration
			shadowView.layer.add(anim, forKey: #keyPath(CALayer.shadowOpacity))
			
		}
		
		shadowView.layer.shadowOpacity = shadowOpacity
		
		isShadowForceDisabled = false

	}
	
	func disableCornerRadius(animated: Bool = false, duration: Double = 0.3) {
		
		if animated {
			
			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = panelNavigationController.view.layer.cornerRadius
			anim.toValue = 0.0
			anim.duration = duration
			panelNavigationController.view.layer.add(anim, forKey: #keyPath(CALayer.cornerRadius))
			
		}
		
		panelNavigationController.view.layer.cornerRadius = 0.0

		panelNavigationController.view.clipsToBounds = true
		
	}
	
	func enableCornerRadius(animated: Bool = false, duration: Double = 0.3) {
	
		if animated {
			
			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = panelNavigationController.view.layer.cornerRadius
			anim.toValue = cornerRadius
			anim.duration = duration
			panelNavigationController.view.layer.add(anim, forKey: #keyPath(CALayer.cornerRadius))
			
		}
		
		panelNavigationController.view.layer.cornerRadius = cornerRadius

		panelNavigationController.view.clipsToBounds = true
		
	}
	
	private var shadowEnabled: Bool {
		return delegate?.enablePanelShadow(for: self) == true
	}
	
	private func updateShadow() {
		
		if isShadowForceDisabled {
			return
		}
		
		if shadowEnabled {

			shadowView.layer.shadowRadius = shadowRadius
			shadowView.layer.shadowOpacity = shadowOpacity
			shadowView.layer.shadowOffset = shadowOffset
			shadowView.layer.shadowColor = shadowColor

		} else {
			
			shadowView.layer.shadowRadius = 0.0
			shadowView.layer.shadowOpacity = 0.0
			
		}
		
	}
	
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
