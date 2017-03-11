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
	
}
