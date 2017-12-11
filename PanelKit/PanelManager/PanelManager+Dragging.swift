//
//  PanelManager+Dragging.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

extension PanelManager {

	func didDragFree(_ panel: PanelViewController, from point: CGPoint) {

		fadePinnedPreviewOut(for: panel)

		guard let pinnedMetadata = panel.pinnedMetadata else {
			return
		}

		let isPinned = panel.isPinned

		guard isPinned || panel.wasPinned else {
			return
		}

		guard let panelView = panel.view else {
			return
		}

		guard let contentDelegate = panel.contentDelegate else {
			return
		}
		
		if panel.logLevel == .full {
			print("did drag \(panel) free from \(point)")
		}

		var prevPinnedPanels = panelsPinned(at: pinnedMetadata.side).sorted { (p1, p2) -> Bool in
			return p1.pinnedMetadata?.index ?? 0 < p2.pinnedMetadata?.index ?? 0
		}

		prevPinnedPanels.remove(at: pinnedMetadata.index)

		panel.pinnedMetadata = nil

		panel.bringToFront()

		panel.enableCornerRadius(animated: true, duration: panelGrowDuration)
		panel.enableShadow(animated: true, duration: panelGrowDuration)

		let side = pinnedMetadata.side

		let currentFrame = panelView.frame

		var newFrame = currentFrame

		let preferredPanelPinnedWidth = contentDelegate.preferredPanelPinnedWidth
		let preferredPanelContentSize = contentDelegate.preferredPanelContentSize
		newFrame.size = panel.floatingSize ?? preferredPanelContentSize

		if side == .right {
			if newFrame.width > preferredPanelPinnedWidth {
				let delta = newFrame.width - preferredPanelPinnedWidth
				newFrame.origin.x -= delta
			}
		}

		if currentFrame.contains(point) && !newFrame.contains(point) {
			if newFrame.minY > point.y || newFrame.maxY < point.y {
				newFrame.origin.y += point.y - newFrame.maxY
			}
		}

		newFrame = panel.allowedFrame(for: newFrame)

		updateFrame(for: panel, to: newFrame)

		if numberOfPanelsPinned(at: side) > 0 {

			for pinnedPanel in panelsPinned(at: side) {

				if pinnedPanel == panel {
					continue
				}

				pinnedPanel.pinnedMetadata?.index = prevPinnedPanels.index(of: pinnedPanel) ?? 0

			}
			
			for pinnedPanel in panelsPinned(at: side) {

				if pinnedPanel == panel {
					continue
				}

				guard let newPosition = pinnedPanelPosition(for: pinnedPanel, at: side) else {
					assertionFailure("Expected a valid position")
					continue
				}

				self.updateFrame(for: pinnedPanel, to: newPosition.frame)

			}

		}

		updateContentViewFrame(to: updatedContentViewFrame())

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {

			self.panelContentWrapperView.layoutIfNeeded()

			self.didUpdatePinnedPanels()

		}, completion: { (_) in

		})

		panel.showResizeHandleIfNeeded()

	}

	func didDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {

		guard allowPanelPinning else {
			return
		}
		
		guard numberOfPanelsPinned(at: side) < maximumNumberOfPanelsPinned(at: side) else {
			return
		}

		guard !panel.isPinned else {
			return
		}

		guard let panelView = panel.view else {
			return
		}

		guard let previewTargetPosition = pinnedPanelPosition(for: panel, at: side) else {
			return
		}

		if let currentPreviewView = panel.panelPinnedPreviewView {

			if currentPreviewView.frame == previewTargetPosition.frame {
				return
			}

		}

		if panel.logLevel == .full {
			print("did drag \(panel) to edge of \(side) side")
		}

		let previewStartFrame = panelView.layer.presentation()?.frame ?? panelView.frame
		
		let previewView = panel.panelPinnedPreviewView ?? UIView(frame: previewStartFrame)
		previewView.isUserInteractionEnabled = false

		previewView.backgroundColor = panel.tintColor
		previewView.alpha = pinnedPanelPreviewAlpha

		panelContentWrapperView.addSubview(previewView)
		panelContentWrapperView.insertSubview(previewView, belowSubview: panelView)

		UIView.animate(withDuration: pinnedPanelPreviewGrowDuration) {

			previewView.frame = previewTargetPosition.frame

		}

		panel.panelPinnedPreviewView = previewView
	}

	func didEndDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {

		let pinnedPreviewView = panel.panelPinnedPreviewView

		fadePinnedPreviewOut(for: panel)

		guard allowPanelPinning else {
			return
		}

		guard numberOfPanelsPinned(at: side) < maximumNumberOfPanelsPinned(at: side) else {
			return
		}
		
		guard !panel.isPinned else {
			return
		}

		guard let panelView = panel.view else {
			return
		}

		guard let position = pinnedPanelPosition(for: panel, at: side) else {
			return
		}

		if panel.logLevel == .full {
			print("did pin \(panel) to edge of \(side) side")
		}

		var prevPinnedPanels = panelsPinned(at: side).sorted { (p1, p2) -> Bool in
			return p1.pinnedMetadata?.index ?? 0 < p2.pinnedMetadata?.index ?? 0
		}

		panel.pinnedMetadata = PanelPinnedMetadata(side: side, index: position.index)

		prevPinnedPanels.insert(panel, at: position.index)

		panel.disableCornerRadius(animated: true, duration: panelGrowDuration)
		panel.disableShadow(animated: true, duration: panelGrowDuration)

		panel.floatingSize = panel.view.frame.size

		if numberOfPanelsPinned(at: side) > 1 {

			for pinnedPanel in panelsPinned(at: side) {

				if pinnedPanel == panel {
					continue
				}

				pinnedPanel.pinnedMetadata?.index = prevPinnedPanels.index(of: pinnedPanel) ?? 0

			}

			for pinnedPanel in panelsPinned(at: side) {

				if pinnedPanel == panel {
					continue
				}
				
				guard let newPosition = pinnedPanelPosition(for: pinnedPanel, at: side) else {
					assertionFailure("Expected a valid position")
					continue
				}

				self.updateFrame(for: pinnedPanel, to: newPosition.frame)

			}

		}

		self.updateFrame(for: panel, to: position.frame)

		updateContentViewFrame(to: updatedContentViewFrame())

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {

			self.panelContentWrapperView.layoutIfNeeded()

			self.didUpdatePinnedPanels()

		}, completion: { (_) in

			// Send panel and preview view to back, so (shadows of) non-pinned panels are on top
			self.panelContentWrapperView.insertSubview(panelView, aboveSubview: self.panelContentView)

			if let pinnedPreviewView = pinnedPreviewView, pinnedPreviewView.superview != nil {
				self.panelContentWrapperView.insertSubview(pinnedPreviewView, aboveSubview: self.panelContentView)
			}

		})

		self.moveAllPanelsToValidPositions()

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {

			self.panelContentWrapperView.layoutIfNeeded()

		})

		panel.hideResizeHandle()

	}

	func didEndDragFree(_ panel: PanelViewController) {

		fadePinnedPreviewOut(for: panel)

	}

}
