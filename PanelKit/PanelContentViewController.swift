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
	
	public var isFloating: Bool {
		
		guard let panel = self.panelNavigationController?.panelViewController else {
			return false
		}
		
		if canFloat {
			return !panel.isPresentedAsPopover
		}
		
		return false
	}
	
    override open func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_ :)), name: .UIKeyboardWillChangeFrame, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_ :)), name: .UIKeyboardWillHide, object: nil)

	}
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		didUpdateFloatingState()
		updateNavigationButtons()

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
	
	func isPresentedModally() -> Bool {
		
		guard let panel = self.panelNavigationController?.panelViewController else {
			return false
		}
		
		if panel.isPresentedAsPopover {
			return false
		}
		
		return panel.presentingViewController != nil
	}
	
	// MARK: -
	
	/// A panel can't float when it is presented modally
	public var canFloat: Bool {
		
		guard let panel = self.panelNavigationController?.panelViewController else {
			return false
		}
		
		if panel.isPresentedAsPopover {
			return true
		}
		
		// Modal
		if isPresentedModally() {
			return false
		}
		
		return true
		
	}
	
	public func dismissPanel() {
		panelNavigationController?.panelViewController?.dismiss(animated: true, completion: nil)
	}
	
	open func didUpdateFloatingState() {
	
		updateNavigationButtons()

	}
	
	open var preferredPanelContentSize: CGSize {
		fatalError("Preferred panel content size not implemented")
	}
	
	// MARK: - Bar button items
	
	/// Excludes potential "close" or "pop" buttons
	open var leftBarButtonItems: [UIBarButtonItem] = []
	
	/// Excludes potential "close" or "pop" buttons
	open var rightBarButtonItems: [UIBarButtonItem] = []

	open var closeButtonTitle = "Close"
	open var popButtonTitle = "⬇︎"
	open var modalCloseButtonTitle = "Back"
	
	private func panelFloatToggleBtnTitle() -> String {
		if isFloating {
			return closeButtonTitle
		} else {
			return popButtonTitle
		}
	}
	
	private func getBackBtn() -> UIBarButtonItem {
		
		let button = UIBarButtonItem(title: modalCloseButtonTitle, style: .done, target: self, action: #selector(dismissPanel))
		
		return button
	}
	
	private func getPanelToggleBtn() -> UIBarButtonItem {
		
		let button = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(popPanel(_:)))
		button.title = panelFloatToggleBtnTitle()
		
		return button
	}
	
	
	func popPanel(_ sender: UIBarButtonItem) {
		
		guard let panel = panelNavigationController?.panelViewController else {
			return
		}
		
		self.panelDelegate?.toggleFloatStatus(for: panel)
		
	}
	
	func updateNavigationButtons() {
		
		if isPresentedModally() {
			
			let backBtn = getBackBtn()

			navigationItem.leftBarButtonItems = leftBarButtonItems + [backBtn]

		} else {
			
			if !canFloat {
				
				navigationItem.leftBarButtonItems = leftBarButtonItems
				
			} else {
				
				let panelToggleBtn = getPanelToggleBtn()
				
				navigationItem.leftBarButtonItems = leftBarButtonItems + [panelToggleBtn]
				
			}
			
		}
		
		navigationItem.rightBarButtonItems = rightBarButtonItems

	}
	
}
