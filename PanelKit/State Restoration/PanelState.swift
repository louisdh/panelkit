//
//  PanelState.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 10/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics

public struct PanelState: Codable {
	
	public let floatingState: PanelFloatingState?
	
	public let pinnedMetadata: PanelPinnedMetadata?

	public let floatingSize: CGSize?
	
	public init(floatingState: PanelFloatingState? = nil, pinnedMetadata: PanelPinnedMetadata? = nil, floatingSize: CGSize? = nil) {
		
		self.floatingState = floatingState
		self.pinnedMetadata = pinnedMetadata
		self.floatingSize = floatingSize
	}
	
	init(_ panel: PanelViewController) {
		
		if panel.isFloating {
			
			if let panelContentWrapperView = panel.manager?.panelContentWrapperView {
				
				let x = panel.view.frame.origin.x / panelContentWrapperView.frame.width
				let y = panel.view.frame.origin.y / panelContentWrapperView.frame.height
				let relPosition = CGPoint(x: x, y: y)
			
				if let zIndex = panelContentWrapperView.subviews.index(of: panel.view) {
					floatingState = PanelFloatingState(relativePosition: relPosition, zIndex: zIndex)
				} else {
					floatingState = nil
				}
				
			} else {
				
				floatingState = nil
				
			}
			
		} else {
			floatingState = nil
		}
		
		floatingSize = panel.floatingSize
		
		pinnedMetadata = panel.pinnedMetadata
		
	}
	
}

extension PanelState: Equatable {
	
	public static func ==(lhs: PanelState, rhs: PanelState) -> Bool {
		return lhs.floatingSize == rhs.floatingSize &&
				lhs.floatingState == rhs.floatingState &&
				lhs.pinnedMetadata == rhs.pinnedMetadata
	}
	
}
