//
//  PanelManager+Dragging.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

extension PanelManager {

	func didDragFree(_ panel: PanelViewController) {

		fadePinnedPreviewOut(for: panel)

		let isPinned = panel.isPinned

		guard isPinned || panel.wasPinned else {
			return
		}

		guard let panelView = panel.view else {
			return
		}

		panel.pinnedSide = nil

		panel.bringToFront()

		panel.enableCornerRadius(animated: true, duration: panelGrowDuration)
		panel.enableShadow(animated: true, duration: panelGrowDuration)

		if isPinned {

			let currentFrame = panelView.frame

			var newFrame = currentFrame
			if let contentSize = panel.contentDelegate?.preferredPanelContentSize {
				newFrame.size = contentSize
			}

			updateFrame(for: panel, to: newFrame)
		}

		updateContentViewFrame(to: updatedContentViewFrame())

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {

			self.panelContentWrapperView.layoutIfNeeded()

			self.didUpdatePinnedPanels()

		}) { (_) in

		}

	}

	func didDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {

		guard allowPanelPinning else {
			return
		}

		guard !panel.isPinned else {
			return
		}

		if let _ = panel.panelPinnedPreviewView {
			return
		}

		if panel.logLevel == .full {
			print("did drag \(panel) to edge of \(side) side")
		}

		guard let panelView = panel.view else {
			return
		}

		let previewView = UIView(frame: panelView.frame)
		previewView.isUserInteractionEnabled = false

		guard let previewTargetFrame = pinnedPanelFrame(for: panel, at: side) else {
			return
		}

		previewView.backgroundColor = panel.tintColor
		previewView.alpha = pinnedPanelPreviewAlpha

		panelContentWrapperView.addSubview(previewView)
		panelContentWrapperView.insertSubview(previewView, belowSubview: panelView)

		UIView.animate(withDuration: pinnedPanelPreviewGrowDuration) {

			previewView.frame = previewTargetFrame

		}

		panel.panelPinnedPreviewView = previewView
	}

	func didEndDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {

		let pinnedPreviewView = panel.panelPinnedPreviewView

		fadePinnedPreviewOut(for: panel)

		guard allowPanelPinning else {
			return
		}

		guard !panel.isPinned else {
			return
		}

		guard let panelView = panel.view else {
			return
		}

		guard let frame = pinnedPanelFrame(for: panel, at: side) else {
			return
		}

		panel.pinnedSide = side

		panel.disableCornerRadius(animated: true, duration: panelGrowDuration)
		panel.disableShadow(animated: true, duration: panelGrowDuration)

		self.moveAllPanelsToValidPositions()
		self.updateFrame(for: panel, to: frame)

		updateContentViewFrame(to: updatedContentViewFrame())

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {

			self.panelContentWrapperView.layoutIfNeeded()

			self.didUpdatePinnedPanels()

		}) { (_) in

			// Send panel and preview view to back, so (shadows of) non-pinned panels are on top
			self.panelContentWrapperView.insertSubview(panelView, aboveSubview: self.panelContentView)

			if let pinnedPreviewView = pinnedPreviewView, pinnedPreviewView.superview != nil {
				self.panelContentWrapperView.insertSubview(pinnedPreviewView, aboveSubview: self.panelContentView)
			}

		}

	}

	func didEndDragFree(_ panel: PanelViewController) {

		fadePinnedPreviewOut(for: panel)

		guard panel.isPinned else {
			return
		}

		panel.pinnedSide = nil

	}

}
