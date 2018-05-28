//
//  Text2PanelContentViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 28/05/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

class Text2PanelContentViewController: UIViewController, PanelContentDelegate {
	
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "TextView 2"
		
	}
	
	var shouldAdjustForKeyboard: Bool {
		return textView.isFirstResponder
	}
	
	var minimumPanelContentSize: CGSize {
		return CGSize(width: 240, height: 260)
	}
	
	let preferredPanelContentSize = CGSize(width: 320, height: 400)
	
	var preferredPanelPinnedHeight: CGFloat {
		return 260
	}
	
}
