//
//  CGRect+Center.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 13/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

extension CGRect {

	var center: CGPoint {
		get {
			let x = origin.x + width / 2.0
			let y = origin.y + height / 2.0

			return CGPoint(x: x, y: y)
		}
		set {

			let x = newValue.x - width / 2.0
			let y = newValue.y - height / 2.0

			let newOrigin = CGPoint(x: x, y: y)

			self.origin = newOrigin

		}
	}

}
