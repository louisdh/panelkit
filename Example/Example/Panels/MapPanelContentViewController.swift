//
//  MapPanelContentViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit
import MapKit

class MapPanelContentViewController: PanelContentViewController {

	fileprivate func getPanelToggleBtn() -> UIBarButtonItem {
		
		let button = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(popPanel(_:)))
		
		if isShownAsPanel {
			button.title = "╳"
		} else {
			button.title = "⬇︎"
		}
		
		return button
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Map"
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateNavigationButtons()
		
	}
	
	func popPanel(_ sender: UIBarButtonItem) {
		
		guard let panel = panelNavigationController?.panelViewController else {
			return
		}
		
		self.panelDelegate?.toggleFloatStatus(for: panel)
		
	}
	
	func updateNavigationButtons() {
		
		if !canFloat {
			
			setPanelToggleHidden(true)
			
		} else {
			
			setPanelToggleHidden(false)
			
			
		}
	}
	
	func setPanelToggleHidden(_ hidden: Bool) {
		
		if hidden {
			
			navigationItem.leftBarButtonItems = []
			
		} else {
			
			let panelToggleBtn = getPanelToggleBtn()
			
			navigationItem.leftBarButtonItems = [panelToggleBtn]
			
		}
		
	}
	
	override func setAsPanel(_ asPanel: Bool) {
		super.setAsPanel(asPanel)
		
		setPanelToggleHidden(!isShownAsPanel)

	}

	override func contentSize() -> CGSize {
		return CGSize(width: 320, height: 500)
	}
	
}
