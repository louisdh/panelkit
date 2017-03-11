//
//  PanelContentViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 30/08/16.
//  Copyright © 2016 Silver Fox. All rights reserved.
//

import UIKit
import CoreGraphics

extension PanelContentDelegate {
	
	func didUpdateFloatingState() {
		
		updateNavigationButtons()
		
	}
	
}

public extension PanelContentDelegate where Self: UIViewController {

	weak var panelNavigationController: PanelNavigationController? {
		return navigationController as? PanelNavigationController
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

	func dismissPanel() {
		panelNavigationController?.panelViewController?.dismiss(animated: true, completion: nil)
	}
	
}

extension PanelContentDelegate where Self: UIViewController {
	
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
		
		let button = BlockBarButtonItem(title: modalCloseButtonTitle, style: .done) {
			self.dismissPanel()
		}
		
		return button
	}
	
	func getPanelToggleBtn() -> UIBarButtonItem {
		
		let button = BlockBarButtonItem(title: "", style: .done) {
			self.popPanel()
		}
		
		button.title = panelFloatToggleBtnTitle()
		
		return button
	}
	
	public func popPanel() {
		
		guard let panel = panelNavigationController?.panelViewController else {
			return
		}
		
		panel.delegate?.toggleFloatStatus(for: panel)
		
	}
	
	
	
}

public protocol PanelContentDelegate: class {
	
	var closeButtonTitle: String { get }
	var popButtonTitle: String { get }
	var modalCloseButtonTitle: String { get }

	var shouldAdjustForKeyboard: Bool { get }
	
	var preferredPanelContentSize: CGSize { get }
	
	func updateConstraintsForKeyboardShow(with frame: CGRect)
	
	func updateUIForKeyboardShow(with frame: CGRect)
	func updateConstraintsForKeyboardHide()
	
	func updateUIForKeyboardHide()
	
	/// Excludes potential "close" or "pop" buttons
	var leftBarButtonItems: [UIBarButtonItem] { get }
	
	/// Excludes potential "close" or "pop" buttons
	var rightBarButtonItems: [UIBarButtonItem] { get }
	
	func dismissPanel()
	func popPanel()
	
	func updateNavigationButtons()
	
}

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
	
}
