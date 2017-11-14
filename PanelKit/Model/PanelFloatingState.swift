//
//  PanelFloatingState.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 14/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics

public struct PanelFloatingState: Codable {
	
	let relativePosition: CGPoint
	let zIndex: Int
	
}

extension PanelFloatingState: Hashable {
	
	static public func ==(lhs: PanelFloatingState, rhs: PanelFloatingState) -> Bool {
		return lhs.relativePosition == rhs.relativePosition && lhs.zIndex == rhs.zIndex
	}
	
	public var hashValue: Int {
		return zIndex.hashValue
	}
	
}
