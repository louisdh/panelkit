//
//  TextPanelContentViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

class TextPanelContentViewController: UIViewController, PanelContentDelegate {

	@IBOutlet weak var textView: UITextView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "TextView"

	}

	var shouldAdjustForKeyboard: Bool {
		return textView.isFirstResponder
	}

	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 400)
	}

}
