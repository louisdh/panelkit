//
//  BlockGestureRecognizer.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 25/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

class BlockGestureRecognizer: NSObject {

	let closure: () -> Void

	init(view: UIView, recognizer: UIGestureRecognizer, closure: @escaping () -> Void) {
		self.closure = closure
		super.init()
		view.addGestureRecognizer(recognizer)
		recognizer.addTarget(self, action: #selector(invokeTarget(_ :)))
	}

	@objc func invokeTarget(_ recognizer: UIGestureRecognizer) {
		self.closure()
	}
}
