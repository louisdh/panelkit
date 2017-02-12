//
//  ViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

class ViewController: UIViewController, PanelManager {
	
	@IBOutlet weak var contentWrapperView: UIView!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var privatePanelPinnedPreviewView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	// MARK: PanelManager
	
	var panelContentWrapperView: UIView {
		return contentWrapperView
	}
	
	var panelContentView: UIView {
		return contentView
	}
	
	var panelPinnedPreviewView: UIView? {
		get {
			return privatePanelPinnedPreviewView
		}
		set {
			privatePanelPinnedPreviewView = newValue
		}
	}
	
	var panels: [PanelViewController?] {
		return []
	}
	
	var allowFloatingPanels: Bool {
		return self.view.bounds.width > 800
	}
	
	var allowPanelPinning: Bool {
		return self.view.bounds.width > 800
	}
	
	func didUpdatePinnedPanels() {
		
		
	}
	
	func enablePanelShadow(for panel: PanelViewController) -> Bool {
		return true
	}
	
}

