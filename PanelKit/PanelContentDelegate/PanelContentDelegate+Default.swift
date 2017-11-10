//
//  PanelContentDelegate+Default.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

public extension PanelContentDelegate {

	var closeButtonTitle: String {
		return "Close"
	}
	var popButtonTitle: String {
		return "⬇︎"
	}

	var modalCloseButtonTitle: String {
		return "Back"
	}

	func updateConstraintsForKeyboardShow(with frame: CGRect) {

	}

	func updateUIForKeyboardShow(with frame: CGRect) {

	}

	func updateConstraintsForKeyboardHide() {

	}

	func updateUIForKeyboardHide() {

	}

	/// Defaults to false
	var shouldAdjustForKeyboard: Bool {
		return false
	}

	/// Excludes potential "close" or "pop" buttons
	var leftBarButtonItems: [UIBarButtonItem] {
		return []
	}

	/// Excludes potential "close" or "pop" buttons
	var rightBarButtonItems: [UIBarButtonItem] {
		return []
	}

	func panelDragGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return true
	}

	var preferredPanelPinnedWidth: CGFloat {
		return preferredPanelContentSize.width
	}

	var minimumPanelContentSize: CGSize {
		return preferredPanelContentSize
	}

	var maximumPanelContentSize: CGSize {
		return preferredPanelContentSize
	}

}

public extension PanelContentDelegate where Self: UIViewController {

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
