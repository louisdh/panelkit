//
//  PanelContentViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 30/08/16.
//  Copyright © 2016 Silver Fox. All rights reserved.
//

import UIKit

public protocol PanelContentViewControllerDelegate: class {
	
	func toggleFloatStatus(for panel: PanelViewController)
	
}

/// Needs to be presented as root view controller in a PanelNavigationController instance
@objc open class PanelContentViewController: UIViewController {

	private var prevTouch: CGPoint?
	internal(set) public weak var panelDelegate: PanelContentViewControllerDelegate?
	
	@objc public weak var panelNavigationController: PanelNavigationController? {
		return navigationController as? PanelNavigationController
	}
	
	private weak var viewToMove: UIView? {
		return panelNavigationController?.panelViewController?.view
	}
	
	
	// Default is false
	internal(set) public var isFloating = false
	
    override open func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillChangeFrame, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_ :)), name: .UIKeyboardWillHide, object: nil)

	}
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

	}
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}

	// MARK - Keyboard

	func keyboardWillChangeFrame(_ notification: Notification) {

	}
	
	func willShowKeyboard(_ notification: Notification) {
		
		guard shouldAdjustForKeyboard else {
			return
		}
		
		guard let userInfo = notification.userInfo else {
			return
		}
		
		let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
		let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
		
		
		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
		
		guard var keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			return
		}
		
		guard let viewToMove = panelNavigationController?.panelViewController?.view else {
			return
		}
		
		guard let superView = viewToMove.superview else {
			return
		}
		
		var keyboardFrameInSuperView = superView.convert(keyboardFrame, from: nil)
		keyboardFrameInSuperView = keyboardFrameInSuperView.intersection(superView.bounds)
		
		keyboardFrame = viewToMove.convert(keyboardFrame, from: nil)
		keyboardFrame = keyboardFrame.intersection(viewToMove.bounds)

//		let keyboardIntersectingFrame = viewToMove.bounds.intersection(superView.bounds)
		
		if isFloating {
			
			if keyboardFrame.intersects(viewToMove.bounds) {
				
				UIView.animate(withDuration: duration, delay: 0.0, options: [animationCurve], animations: {
					
					let maxHeight = superView.bounds.height - keyboardFrameInSuperView.height
					
					let height = min(viewToMove.frame.height, maxHeight)
					
					let y = keyboardFrameInSuperView.origin.y - height
					
					viewToMove.frame = CGRect(x: viewToMove.frame.origin.x, y: y, width: viewToMove.frame.width, height: height)
					
				}, completion: nil)
				
				setAutoResizingMask()
				
			}
			
		}
		
		updateConstraintsForKeyboardShow(with: keyboardFrame)
		
		UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: {
			
			self.view.layoutIfNeeded()
			self.updateUIForKeyboardShow(with: keyboardFrame)
			
		}, completion: nil)
		
		
	}
	
	func willHideKeyboard(_ notification: Notification) {
		
		guard let viewToMove = panelNavigationController?.panelViewController?.view else {
			return
		}
		
		guard let userInfo = notification.userInfo else {
			return
		}
		
		let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
		let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
		
		
		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

		
		let currentFrame = viewToMove.frame
		
		var newFrame = currentFrame
		newFrame.size = preferredPanelContentSize
		
		
		updateConstraintsForKeyboardHide()
		
		UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: {
			
			viewToMove.frame = newFrame
			self.view.layoutIfNeeded()
			self.updateUIForKeyboardHide()
			
		}, completion: nil)
		
	}

	open func updateConstraintsForKeyboardShow(with frame: CGRect) {

		
	}
	
	open func updateUIForKeyboardShow(with frame: CGRect) {
		
		
	}
	
	open func updateConstraintsForKeyboardHide() {
		
		
	}
	
	open func updateUIForKeyboardHide() {
		
		
	}
	
	/// Defaults to false
	open var shouldAdjustForKeyboard: Bool {
		return false
	}

	// MARK: -

	private var position: CGPoint?
	private var positionInFullscreen: CGPoint?
	
	// MARK: - Move off screen
	
	@objc func prepareMoveOffScreen() {
		
		position = viewToMove?.center

	}
	
	private let deltaToMoveOffscreen: CGFloat = 400

	@objc func movePanelOffScreen() {
		
		guard let viewToMove = self.viewToMove else {
			return
		}
		
		guard let superView = viewToMove.superview else {
			return
		}

		if viewToMove.center.x < superView.frame.size.width/2.0 {
			viewToMove.center = CGPoint(x: -deltaToMoveOffscreen, y: viewToMove.center.y)
		} else {
			viewToMove.center = CGPoint(x: superView.frame.size.width + deltaToMoveOffscreen, y: viewToMove.center.y)
		}
		
	}

	@objc func completeMoveOffScreen() {

		positionInFullscreen = viewToMove?.center

	}
	
	// MARK: - Move on screen

	@objc func prepareMoveOnScreen() {
		
		guard let position = position else {
			return
		}
		
		guard let positionInFullscreen = positionInFullscreen else {
			return
		}
		
		guard let viewToMove = self.viewToMove else {
			return
		}
		
		let x = position.x - (positionInFullscreen.x - viewToMove.center.x)
		let y = position.y - (positionInFullscreen.y - viewToMove.center.y)
		
		self.position = CGPoint(x: x, y: y)
	}
	
	@objc func movePanelOnScreen() {
		
		guard let position = position else {
			return
		}
		
		viewToMove?.center = position
		
	}
	
	@objc func completeMoveOnScreen() {
		
		
	}
	
	// MARK: -
	
	// TODO: can be removed?
	func setAutoResizingMask() {

		guard let viewToMove = self.viewToMove else {
			return
		}
		
		guard let superview = viewToMove.superview else {
			return
		}
		
		var mask: UIViewAutoresizing

		if viewToMove.center.x > superview.frame.size.width/2.0 {
			
			mask = .flexibleLeftMargin
			
		} else {
			
			mask = .flexibleRightMargin
			
		}
		
		if panelNavigationController?.panelViewController?.isPinned == true {
			mask.formUnion(.flexibleHeight)
		}
		
		mask.formUnion(.flexibleTopMargin)
		mask.formUnion(.flexibleBottomMargin)
		
		viewToMove.autoresizingMask = mask
		
	}
	
	/// A panel can't float when it is presented modally
	public var canFloat: Bool {
		
		guard let panel = self.panelNavigationController?.panelViewController else {
			return false
		}
		
		if panel.isPresentedAsPopover {
			return true
		}
		
		// Modal
		if panel.presentingViewController != nil {
			return false
		}
		
		return true
		
	}
	
	func setAsPanel(_ asPanel: Bool) {
		
		isFloating = asPanel
		didUpdateFloatingState()
		
	}
	
	open func didUpdateFloatingState() {
		
	}
	
	open var preferredPanelContentSize: CGSize {
		fatalError("Preferred panel content size not implemented")
	}
	
}
