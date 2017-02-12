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
	
	func dragAreaInsets(for panel: PanelViewController) -> UIEdgeInsets

	func enablePanelShadow(for panel: PanelViewController) -> Bool
	
}

@objc public class PanelViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

	// TODO: make internal?
	@objc public let panelNavigationController: PanelNavigationController
	
	@objc public weak var contentViewController: PanelContentViewController?
	
	var pinnedSide: PanelPinSide?
	
	var isPinned: Bool {
		return pinnedSide != nil
	}
	
	public weak var delegate: PanelViewControllerDelegate? {
		didSet {
			self.updateShadow()
		}
	}
	
	private let shadowView: UIView

	private let cornerRadius: CGFloat = 16.0
	
	private let shadowRadius: CGFloat = 4.0
	private let shadowOpacity: Float = 0.7
	private let shadowOffset: CGSize = .zero
	private let shadowColor =  UIColor.black.cgColor
	
	var tintColor: UIColor {
		return panelNavigationController.navigationBar.tintColor
	}
	
	// MARK: -

	public init(with contentViewController: PanelContentViewController) {
		
		self.contentViewController = contentViewController
		
		self.panelNavigationController = PanelNavigationController(rootViewController: contentViewController)
//		panelNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
		
		self.shadowView = UIView(frame: .zero)
		
		super.init(nibName: nil, bundle: nil)
	
		self.view.addSubview(shadowView)
		self.view.addSubview(panelNavigationController.view)
		
		panelNavigationController.panelViewController = self
	
		panelNavigationController.navigationBar.tintColor = contentViewController.view.tintColor
		
		self.updateShadow()
	
		self.view.clipsToBounds = false
		
		panelNavigationController.view.layer.cornerRadius = cornerRadius
		panelNavigationController.view.clipsToBounds = true
		
		
//		panelNavigationController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
//		panelNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
//		panelNavigationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//		panelNavigationController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
//		self.presentationController?.delegate = self
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		contentViewController?.viewWillAppear(animated)
		
		print("\(self) viewWillAppear")
	}
	
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		contentViewController?.viewDidAppear(animated)

		print("\(self) viewDidAppear")
	}
	
	override public func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
	}
	
	override public func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if panelNavigationController.isShownAsPanel {
			self.view.frame.size = panelNavigationController.view.frame.size
		} else {
			panelNavigationController.view.frame = self.view.bounds
		}
		
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
	
	// MARK: -

	var isShownAsPanel: Bool {
		
		guard let contentViewController = contentViewController else {
			return false
		}
	
		return contentViewController.isShownAsPanel
	}
	
	@objc override public var preferredContentSize: CGSize {
		get {
			return contentViewController?.contentSize() ?? super.preferredContentSize
		}
		set {
			super.preferredContentSize = newValue
		}
	}
	
	// MARK: -
	
	func didDrag() {
		
		guard isShownAsPanel else {
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
		
		guard isShownAsPanel else {
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
	
	public func allowedCenter(for proposedCenter: CGPoint) -> CGPoint {
		
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
		print("deinit \(self)")
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
//	func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//		
//		if style == .popover {
//			return self
//		}
//		
//		return panelNavigationController
//		
//	}
	
	// MARK: -

	func disableShadow() {
		
		shadowView.layer.shadowOpacity = 0.0

	}
	
	func enableShadow() {
		
		shadowView.layer.shadowOpacity = shadowOpacity
		
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
		// PanelViewController currently doesn't support status bar 
		// because it causes glitches when presented as a modal
		return true
	}
	
	override public var preferredStatusBarStyle: UIStatusBarStyle {
		
		if let contentViewController = contentViewController {
			return contentViewController.preferredStatusBarStyle
		}
		
		return .lightContent
	}
	
}
