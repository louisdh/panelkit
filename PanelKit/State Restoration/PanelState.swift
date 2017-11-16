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
	
	let floatingState: PanelFloatingState?
	
	let pinnedMetadata: PanelPinnedMetadata?

	let floatingSize: CGSize?
	
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
		
		pinnedMetadata = panel.pinnedSide
		
	}
	
}

extension PanelState: Equatable {
	
	public static func ==(lhs: PanelState, rhs: PanelState) -> Bool {
		return lhs.floatingSize == rhs.floatingSize &&
				lhs.floatingState == rhs.floatingState &&
				lhs.pinnedMetadata == rhs.pinnedMetadata
	}
	
}
