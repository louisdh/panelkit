//
//  TextPanelContentViewController.swift
//  PanelKitTests
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import PanelKit

class TextPanelContentViewController: PanelContentViewController {

	weak var textView: UITextView!

	override func viewDidLoad() {
		super.viewDidLoad()

		textView = UITextView(frame: view.bounds)
		self.view.addSubview(textView)
		
		self.title = "TextView"

	}

	override var shouldAdjustForKeyboard: Bool {
		return textView.isFirstResponder
	}

	override var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 400)
	}

}
