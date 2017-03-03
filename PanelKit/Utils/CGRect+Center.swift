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

			return CGPoint(x: midX, y: midY)
		}
		set {

			let dx = newValue.x - center.x
			let dy = newValue.y - center.y

			self = self.offsetBy(dx: dx, dy: dy)

		}
	}

}
