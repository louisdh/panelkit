//
//  PanelContentDelegate+Navigation.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

public extension PanelContentDelegate where Self: UIViewController {

	weak var panelNavigationController: PanelNavigationController? {
		return navigationController as? PanelNavigationController
	}

}

extension PanelContentDelegate {

	func didUpdateFloatingState() {

		updateNavigationButtons()

	}

}

extension PanelContentDelegate where Self: UIViewController {

	func dismissPanel() {
		panelNavigationController?.panelViewController?.dismiss(animated: true, completion: nil)
	}

	func popPanel() {

		guard let panel = panelNavigationController?.panelViewController else {
			return
		}

		panel.delegate?.toggleFloatStatus(for: panel)

	}

	func panelFloatToggleBtnTitle() -> String {

		guard let panel = panelNavigationController?.panelViewController else {
			return closeButtonTitle
		}

		if panel.isFloating || panel.isPinned {
			return closeButtonTitle
		} else {
			return popButtonTitle
		}
	}

	func getBackBtn() -> UIBarButtonItem {

		let button = BlockBarButtonItem(title: modalCloseButtonTitle, style: .done) { [weak self] in
			self?.dismissPanel()
		}

		return button
	}

	func getPanelToggleBtn() -> UIBarButtonItem {

		let button = BlockBarButtonItem(title: "", style: .done) { [weak self] in
			self?.popPanel()
		}

		button.title = panelFloatToggleBtnTitle()

		return button
	}

}
