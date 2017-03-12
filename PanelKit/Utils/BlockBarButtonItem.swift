//
//  BlockBarButtonItem.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

class BlockBarButtonItem: UIBarButtonItem {
	
	private var actionHandler: ((Void) -> Void)?

	convenience init(title: String?, style: UIBarButtonItemStyle, actionHandler: ((Void) -> Void)?) {
		self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed))
		self.target = self
		self.actionHandler = actionHandler
	}

	convenience init(image: UIImage?, style: UIBarButtonItemStyle, actionHandler: ((Void) -> Void)?) {
		self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed))
		self.target = self
		self.actionHandler = actionHandler
	}

	func barButtonItemPressed(sender: UIBarButtonItem) {
		actionHandler?()
	}

}
