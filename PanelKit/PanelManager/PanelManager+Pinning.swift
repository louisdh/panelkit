//
//  PanelManager+Pinning.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelManager {

	var panelPinnedLeft: PanelViewController? {
		return panelsPinnedLeft.first
	}
	
	var panelsPinnedLeft: [PanelViewController] {
		return panelsPinned(at: .left)
	}
	
	var numberOfPanelsPinnedLeft: Int {
		return numberOfPanelsPinned(at: .left)
	}

	var panelPinnedRight: PanelViewController? {
		return panelsPinnedRight.first
	}

	var panelsPinnedRight: [PanelViewController] {
		return panelsPinned(at: .right)
	}
	
	var numberOfPanelsPinnedRight: Int {
		return numberOfPanelsPinned(at: .right)
	}
	
	func panelsPinned(at side: PanelPinSide) -> [PanelViewController] {
		return panels.filter { $0.pinnedSide?.side == side }.sorted(by: { (p1, p2) -> Bool in
			
			guard let date1 = p1.pinnedSide?.date else {
				return true
			}
			
			guard let date2 = p2.pinnedSide?.date else {
				return true
			}
			
			return date1 < date2
		})
	}
	
	func numberOfPanelsPinned(at side: PanelPinSide) -> Int {
		return panelsPinned(at: side).count
	}
	
}

extension PanelManager {

	func pinnedPanelPosition(for panel: PanelViewController, at side: PanelPinSide) -> PinnedPosition? {

		guard let panelView = panel.view else {
			return nil
		}
		
		guard let contentDelegate = panel.contentDelegate else {
			return nil
		}

		var previewTargetFrame = panelView.bounds
		
		if let panelPinned = panelsPinned(at: side).first {
			
			if let preferredPanelPinnedWidth = panelPinned.contentDelegate?.preferredPanelPinnedWidth {
				previewTargetFrame.size.width = preferredPanelPinnedWidth
			}

		} else {
			
			previewTargetFrame.size.width = contentDelegate.preferredPanelPinnedWidth

		}
		
		previewTargetFrame.origin.y = panelContentView.frame.origin.y

		let totalAvailableHeight = panelContentWrapperView.bounds.height - previewTargetFrame.origin.y
		
		previewTargetFrame.size.height = totalAvailableHeight

		let index: Int
		
		switch side {
		case .left:
			previewTargetFrame.origin.x = 0.0
			
			if numberOfPanelsPinnedLeft > 0 {
				
				previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedLeft + 1)
				
				index = Int(floor((panelView.frame.center.y - panelContentView.frame.origin.y) / previewTargetFrame.size.height))

			} else {
				index = 0
			}
			
		case .right:
			previewTargetFrame.origin.x = panelContentWrapperView.bounds.width - previewTargetFrame.size.width
			
			if panel.isPinned {
				
				if numberOfPanelsPinnedRight > 1 {
					
//					let sortedPanels = panelsPinnedRight.sorted(by: { (p1, p2) -> Bool in
//
//						let y1 = p1.view.frame.origin.y
//						let y2 = p2.view.frame.origin.y
//
//						return y1 < y2
//					})
					
					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedRight)

//					guard let i = sortedPanels.index(of: panel) else {
//						assertionFailure("Expected to find panel")
//						index = 0
//						break
//					}
//
//					index = i

					
//					var possibleIndices = Array(0..<numberOfPanelsPinnedRight)
//
//					for pinnedPanel in panelsPinned(at: side) {
//
//						if pinnedPanel == panel {
//							continue
//						}
//
//						guard let index = pinnedPanel.pinnedSide?.index else {
//							assertionFailure("pinnedSide should not be nil")
//							continue
//						}
//
//						if let i = possibleIndices.index(of: index) {
//							possibleIndices.remove(at: i)
//						}
//
//					}
					
//					index = possibleIndices.first ?? 0
					
					index = panel.pinnedSide?.index ?? 0
					
				} else {
					index = 0
				}
				
			} else {
				
				if numberOfPanelsPinnedRight > 0 {
					
					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedRight + 1)
					
					index = Int(floor((panelView.frame.center.y - panelContentView.frame.origin.y) / previewTargetFrame.size.height))
					
				} else {
					index = 0
				}
				
			}
		
		}
		
		if index > 0 {
			previewTargetFrame.origin.y += previewTargetFrame.size.height * CGFloat(index)
		}
		
		return PinnedPosition(frame: previewTargetFrame, index: index)
	}

	func updatedContentViewFrame() -> CGRect {

		var updatedContentViewFrame = panelContentView.frame

		updatedContentViewFrame.size.width = panelContentWrapperView.bounds.width

		updatedContentViewFrame.origin.x = 0.0

		if let leftPanelWidth = panelPinnedLeft?.contentDelegate?.preferredPanelPinnedWidth {

			updatedContentViewFrame.size.width -= leftPanelWidth

			updatedContentViewFrame.origin.x = leftPanelWidth
		}
		
		if let rightPanelWidth = panelPinnedRight?.contentDelegate?.preferredPanelPinnedWidth {

			updatedContentViewFrame.size.width -= rightPanelWidth

		}

		return updatedContentViewFrame
	}

	func fadePinnedPreviewOut(for panel: PanelViewController) {

		if let panelPinnedPreviewView = panel.panelPinnedPreviewView {

			UIView.animate(withDuration: pinnedPanelPreviewFadeDuration, animations: {
				panelPinnedPreviewView.alpha = 0.0
			}, completion: { (_) in
				panelPinnedPreviewView.removeFromSuperview()
			})

			panel.panelPinnedPreviewView = nil
		}

	}

}
