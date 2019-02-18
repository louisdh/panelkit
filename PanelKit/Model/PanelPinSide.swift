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
	case top
	case bottom
}

public extension PanelPinSide {
    
    public var isVertical: Bool {
        
        let sides: [PanelPinSide]
        
        sides = [.top, .bottom]
        
        return sides.contains(self)
    }
    
    public var isHorizontal: Bool {
        
        let sides: [PanelPinSide]
        
        sides = [.left, .right]
        
        return sides.contains(self)
    }
}

extension PanelPinSide: CustomStringConvertible {

	public var description: String {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		case .top:
			return "top"
		case .bottom:
			return "bottom"
		}
	}

}
