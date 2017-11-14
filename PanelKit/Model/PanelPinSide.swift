//
//  PanelPinSide.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

/// The sides that a panel can be pinned to.
@objc public enum PanelPinSide: Int, Codable {
	case left
	case right
}

extension PanelPinSide: CustomStringConvertible {

	public var description: String {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		}
	}

}
