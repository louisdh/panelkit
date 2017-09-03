//
//  TextPanelContentViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 01/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import PanelKit
import UIKit

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
