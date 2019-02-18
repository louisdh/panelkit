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
	
	var panelPinnedTop: PanelViewController? {
		return panelsPinnedTop.first
	}
	
	var panelsPinnedTop: [PanelViewController] {
		return panelsPinned(at: .top)
	}
	
	var numberOfPanelsPinnedTop: Int {
		return numberOfPanelsPinned(at: .top)
	}
	
	var panelPinnedBottom: PanelViewController? {
		return panelsPinnedBottom.first
	}
	
	var panelsPinnedBottom: [PanelViewController] {
		return panelsPinned(at: .bottom)
	}
	
	var numberOfPanelsPinnedBottom: Int {
		return numberOfPanelsPinned(at: .bottom)
	}

	func panelsPinned(at side: PanelPinSide) -> [PanelViewController] {
		return panels.filter { $0.pinnedMetadata?.side == side }.sorted(by: { (p1, p2) -> Bool in

			guard let date1 = p1.pinnedMetadata?.date else {
				return true
			}

			guard let date2 = p2.pinnedMetadata?.date else {
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
			
			if side == .left || side == .right {
				
				if let preferredPanelPinnedWidth = panelPinned.contentDelegate?.preferredPanelPinnedWidth {
					previewTargetFrame.size.width = preferredPanelPinnedWidth
				}
				
			} else {
				
				if let preferredPanelPinnedHeight = panelPinned.contentDelegate?.preferredPanelPinnedHeight {
					previewTargetFrame.size.height = preferredPanelPinnedHeight
				}
			}

		} else {

			if side == .left || side == .right {

				previewTargetFrame.size.width = contentDelegate.preferredPanelPinnedWidth

			} else {
				
				previewTargetFrame.size.height = contentDelegate.preferredPanelPinnedHeight

			}

		}
		
		if side == .left || side == .right {

			previewTargetFrame.origin.y = panelContentWrapperView.bounds.origin.y
			
			let totalAvailableHeight = panelContentWrapperView.bounds.height
			
			previewTargetFrame.size.height = totalAvailableHeight
			
		} else {
			
			previewTargetFrame.origin.x = panelContentView.frame.origin.x
			
			let totalAvailableWidth = panelContentView.bounds.width
			
			previewTargetFrame.size.width = totalAvailableWidth
			
		}

		let index: Int

		switch side {
			
		case .top:
			previewTargetFrame.origin.y = 0.0
			
			if panel.isPinned {
				
				if numberOfPanelsPinnedTop > 1 {
					
					previewTargetFrame.size.width /= CGFloat(numberOfPanelsPinnedTop)
					
					index = panel.pinnedMetadata?.index ?? 0
					
				} else {
					index = 0
				}
				
			} else {
				
				if numberOfPanelsPinnedTop > 0 {
					
					previewTargetFrame.size.width /= CGFloat(numberOfPanelsPinnedTop + 1)
					
					index = Int(floor((panelView.frame.center.x - panelContentView.frame.origin.x) / previewTargetFrame.size.width))
					
				} else {
					index = 0
				}
				
			}
			
		case .bottom:
			previewTargetFrame.origin.y = panelContentWrapperView.bounds.height - previewTargetFrame.size.height
			
			if panel.isPinned {
				
				if numberOfPanelsPinnedBottom > 1 {
					
					previewTargetFrame.size.width /= CGFloat(numberOfPanelsPinnedBottom)
					
					index = panel.pinnedMetadata?.index ?? 0
					
				} else {
					index = 0
				}
				
			} else {
				
				if numberOfPanelsPinnedBottom > 0 {
					
					previewTargetFrame.size.width /= CGFloat(numberOfPanelsPinnedBottom + 1)
					
					index = Int(floor((panelView.frame.center.x - panelContentView.frame.origin.x) / previewTargetFrame.size.width))
					
				} else {
					index = 0
				}
				
			}
			
		case .left:
			previewTargetFrame.origin.x = 0.0

			if panel.isPinned {

				if numberOfPanelsPinnedLeft > 1 {

					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedLeft)

					index = panel.pinnedMetadata?.index ?? 0

				} else {
					index = 0
				}

			} else {

				if numberOfPanelsPinnedLeft > 0 {

					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedLeft + 1)

					index = Int(floor((panelView.frame.center.y - panelContentWrapperView.bounds.origin.y) / previewTargetFrame.size.height))

				} else {
					index = 0
				}

			}

		case .right:
			previewTargetFrame.origin.x = panelContentWrapperView.bounds.width - previewTargetFrame.size.width

			if panel.isPinned {

				if numberOfPanelsPinnedRight > 1 {

					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedRight)

					index = panel.pinnedMetadata?.index ?? 0

				} else {
					index = 0
				}

			} else {

				if numberOfPanelsPinnedRight > 0 {

					previewTargetFrame.size.height /= CGFloat(numberOfPanelsPinnedRight + 1)

					index = Int(floor((panelView.frame.center.y - panelContentWrapperView.bounds.origin.y) / previewTargetFrame.size.height))

				} else {
					index = 0
				}

			}

		}

		if index > 0 {
			if side == .left || side == .right {
				previewTargetFrame.origin.y += previewTargetFrame.size.height * CGFloat(index)
			} else {
				previewTargetFrame.origin.x += previewTargetFrame.size.width * CGFloat(index)
			}
		}

		return PinnedPosition(frame: previewTargetFrame, index: index)
	}

	func updatedContentViewFrame() -> CGRect {

		var updatedContentViewFrame = panelContentView.frame

		updatedContentViewFrame.size.width = panelContentWrapperView.bounds.width

		updatedContentViewFrame.origin.x = 0.0
		
		updatedContentViewFrame.size.height = panelContentWrapperView.bounds.height
		
		updatedContentViewFrame.origin.y = 0.0

		if let leftPanelWidth = panelPinnedLeft?.contentDelegate?.preferredPanelPinnedWidth {

			updatedContentViewFrame.size.width -= leftPanelWidth

			updatedContentViewFrame.origin.x = leftPanelWidth
		}
		
		if let rightPanelWidth = panelPinnedRight?.contentDelegate?.preferredPanelPinnedWidth {

			updatedContentViewFrame.size.width -= rightPanelWidth

		}
		
		if let topPanelHeight = panelPinnedTop?.contentDelegate?.preferredPanelPinnedHeight {
			
			updatedContentViewFrame.size.height -= topPanelHeight
			
			updatedContentViewFrame.origin.y = topPanelHeight
		}
		
		if let bottomPanelHeight = panelPinnedBottom?.contentDelegate?.preferredPanelPinnedHeight {
			
			updatedContentViewFrame.size.height -= bottomPanelHeight
			
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

public extension PanelManager {

	func pin(_ panel: PanelViewController, to side: PanelPinSide, atIndex index: Int) {
		
		guard allowPanelPinning else {
			return
		}
		
		guard numberOfPanelsPinned(at: side) < maximumNumberOfPanelsPinned(at: side) else {
			return
		}
		
		if !panel.isFloating {
			toggleFloatStatus(for: panel, animated: false)
		}
		
		guard panel.isFloating || panel.isPinned else {
			return
		}
		
		let pinnedPreviewView = panel.panelPinnedPreviewView
		
		fadePinnedPreviewOut(for: panel)
		
		guard !panel.isPinned else {
			return
		}
		
		guard let panelView = panel.view else {
			return
		}
		
		if panel.logLevel == .full {
			print("did pin \(panel) to edge of \(side) side")
		}
		
		var prevPinnedPanels = panelsPinned(at: side).sorted { (p1, p2) -> Bool in
			return p1.pinnedMetadata?.index ?? 0 < p2.pinnedMetadata?.index ?? 0
		}
		
		panel.pinnedMetadata = PanelPinnedMetadata(side: side, index: index)
		
		prevPinnedPanels.insert(panel, at: index)
		
		panel.disableCornerRadius(animated: false, duration: panelGrowDuration)
		panel.disableShadow(animated: false, duration: panelGrowDuration)
		
		guard let position = pinnedPanelPosition(for: panel, at: side) else {
			assertionFailure("Expected a valid position")
			return
		}
		
		self.updateFrame(for: panel, to: position.frame)
		
		if numberOfPanelsPinned(at: side) > 1 {
			
			for pinnedPanel in panelsPinned(at: side) {
				
				if pinnedPanel == panel {
					continue
				}
				
				pinnedPanel.pinnedMetadata?.index = prevPinnedPanels.index(of: pinnedPanel) ?? 0
				
				guard let newPosition = pinnedPanelPosition(for: pinnedPanel, at: side) else {
					assertionFailure("Expected a valid position")
					continue
				}
				
				self.updateFrame(for: pinnedPanel, to: newPosition.frame)
				
			}
			
		}
		
		updateContentViewFrame(to: updatedContentViewFrame())
		
		self.panelContentWrapperView.layoutIfNeeded()
		
		self.didUpdatePinnedPanels()
        
        self.panelManager(self, didUpdatePinnedStateFor: panel)
		
		// Send panel and preview view to back, so (shadows of) non-pinned panels are on top
		self.panelContentWrapperView.insertSubview(panelView, aboveSubview: self.panelContentView)
		
		if let pinnedPreviewView = pinnedPreviewView, pinnedPreviewView.superview != nil {
			self.panelContentWrapperView.insertSubview(pinnedPreviewView, aboveSubview: self.panelContentView)
		}
		
		self.moveAllPanelsToValidPositions()
		
		self.panelContentWrapperView.layoutIfNeeded()

		panel.hideResizeHandle(animated: false)
		
		panel.viewWillAppear(false)
		panel.viewDidAppear(false)

	}
	
}

