//
//  PanelManager+State.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 14/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics

extension PanelManager {
	
	public var panelStates: [Int: PanelState] {
		
		var states = [Int: PanelState]()
		
		for panel in panels {
			
			if let id = (panel.contentViewController as? PanelStateCoder)?.panelId {
				
				states[id] = PanelState(panel)
				
			}
			
		}
		
		return states
	}
	
	func panelForId(_ id: Int) -> PanelViewController? {
		
		for panel in panels {
			
			if let panelId = (panel.contentViewController as? PanelStateCoder)?.panelId, panelId == id {
				
				return panel
				
			}
			
		}
		
		return nil
	}
	
	public func restorePanelStates(_ states: [Int: PanelState]) {
		
		var pinnedTable = [PanelPinnedMetadata: PanelViewController]()
		
		var pinnedMetadatas = [PanelPinnedMetadata]()
		
		
		var floatTable = [PanelFloatingState: PanelViewController]()
		
		var floatStates = [PanelFloatingState]()
		
		for (id, state) in states {
			
			guard let panel = panelForId(id) else {
				continue
			}
			
			panel.floatingSize = state.floatingSize
			
			if let pinnedMetadata = state.pinnedMetadata {
				
				pinnedTable[pinnedMetadata] = panel
				pinnedMetadatas.append(pinnedMetadata)
				
			} else if let floatingState = state.floatingState {
				
				floatTable[floatingState] = panel
				floatStates.append(floatingState)
				
			}
			
		}
		
		pinnedMetadatas.sort { (lhs, rhs) -> Bool in
			return lhs.index < rhs.index
		}
		
		for pinnedMetadata in pinnedMetadatas {
			
			guard let panel = pinnedTable[pinnedMetadata] else {
				continue
			}
			
			pin(panel, to: pinnedMetadata.side, atIndex: pinnedMetadata.index)
			
		}
		
		floatStates.sort { (lhs, rhs) -> Bool in
			return lhs.zIndex < rhs.zIndex
		}
		
		for floatingState in floatStates {
			
			guard let panel = floatTable[floatingState] else {
				continue
			}
			
			var pos = floatingState.relativePosition
			
			pos.x *= panelContentWrapperView.frame.width
			pos.y *= panelContentWrapperView.frame.height
			
			let size: CGSize
			
			if let floatingSize = panel.floatingSize {
				
				size = floatingSize
				
			} else {
				
				size = panel.preferredContentSize
				
			}
			
			let frame = CGRect(origin: pos, size: size)
			
			float(panel, at: frame)
			
		}
		
	}
	
}
