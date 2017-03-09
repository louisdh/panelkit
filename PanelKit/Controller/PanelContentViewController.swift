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

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		didUpdateFloatingState()
		updateNavigationButtons()

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

	func prepareMoveOffScreen() {

		position = viewToMove?.center

	}

	// FIXME: make panel width
	private let deltaToMoveOffscreen: CGFloat = 400

	func movePanelOffScreen() {

		guard let viewToMove = self.viewToMove else {
			return
		}

		guard let superView = viewToMove.superview else {
			return
		}

		// FIXME: use updateFrame
		if viewToMove.center.x < superView.frame.size.width/2.0 {
			viewToMove.center = CGPoint(x: -deltaToMoveOffscreen, y: viewToMove.center.y)
		} else {
			viewToMove.center = CGPoint(x: superView.frame.size.width + deltaToMoveOffscreen, y: viewToMove.center.y)
		}

	}

	func completeMoveOffScreen() {

		positionInFullscreen = viewToMove?.center

	}

	// MARK: - Move on screen

	func prepareMoveOnScreen() {

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

	func movePanelOnScreen() {

		guard let position = position else {
			return
		}

		// FIXME: use updateFrame
		viewToMove?.center = position

	}

	func completeMoveOnScreen() {

	}

	// MARK: -

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
	open var leftBarButtonItems: [UIBarButtonItem] {
		return []
	}

	/// Excludes potential "close" or "pop" buttons
	open var rightBarButtonItems: [UIBarButtonItem] {
		return []
	}

	open var closeButtonTitle = "Close"
	open var popButtonTitle = "⬇︎"
	open var modalCloseButtonTitle = "Back"

	private func panelFloatToggleBtnTitle() -> String {

		guard let panel = panelNavigationController?.panelViewController else {
			return closeButtonTitle
		}

		if panel.isFloating || panel.isPinned {
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

		guard let panel = panelNavigationController?.panelViewController else {
			return
		}

		if panel.isPresentedModally {

			let backBtn = getBackBtn()

			navigationItem.leftBarButtonItems = [backBtn] + leftBarButtonItems

		} else {

			if !panel.canFloat {

				navigationItem.leftBarButtonItems = leftBarButtonItems

			} else {

				let panelToggleBtn = getPanelToggleBtn()

				navigationItem.leftBarButtonItems = [panelToggleBtn] + leftBarButtonItems

			}

		}

		navigationItem.rightBarButtonItems = rightBarButtonItems

	}

}
