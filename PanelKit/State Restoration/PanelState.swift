//
//  PanelState.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 10/11/2017.
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
			
			toggleFloatStatus(for: panel, animated: false)
			
			var pos = floatingState.relativePosition
			
			pos.x *= panelContentWrapperView.frame.width
			pos.y *= panelContentWrapperView.frame.height
			
			let size: CGSize
			
			if let floatingSize = panel.floatingSize {
				
				size = floatingSize
				
			} else {
				
				size = panel.preferredContentSize
				
			}
			
			updateFrame(for: panel, to: CGRect(origin: pos, size: size))
			
			panel.viewWillAppear(false)
			panel.viewDidAppear(false)
			
		}
		
		
	}
	
}
