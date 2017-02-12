//
//  PanelManager.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

public protocol PanelsFullscreenTransitionDelegate {
	
	func panelsPrepareMoveOffScreen()
	func panelsPrepareMoveOnScreen()
	
	func panelsMovePanelOnScreen()
	func panelsMovePanelOffScreen()
	
	func panelsCompleteMoveOnScreen()
	func panelsCompleteMoveOffScreen()
	
}

// MARK: -

public protocol PanelManager: PanelViewControllerDelegate, PanelsFullscreenTransitionDelegate {
	
	var panels: [PanelViewController?] { get }
	
	var allowFloatingPanels: Bool { get	}
	
	var allowPanelPinning: Bool { get }
	
	var panelPinnedPreviewView: UIView? { get set }
	
	var panelContentWrapperView: UIView { get }
	
	var panelContentView: UIView { get }
	
	func didUpdatePinnedPanels()
	
}

// MARK: -

public extension PanelManager where Self: UIViewController {
	
	func closeAllPanels() {
		
		for panel in panels {
			
			guard let panel = panel else {
				continue
			}
			
			guard let panelSuperview = panel.view.superview else {
				continue
			}
			
			guard panelSuperview == panelContentWrapperView else {
				continue
			}
			
			panel.view.removeFromSuperview()
			
			panel.contentViewController?.setAsPanel(false)
			
			if panel.isPinned == true {
				didDragFree(panel)
			}
			
		}
		
	}
	
	/// E.g. to move after a panel pins
	func moveAllPanelsToValidPositions() {
		
		for panel in panels {
			
			guard let panel = panel else {
				continue
			}
			
			panel.view.center = panel.allowedCenter(for: panel.view.center)
			
		}
		
	}
	
	var panelPinnedLeft: PanelViewController? {
		
		for panel in panels {
			if panel?.pinnedSide == .left {
				return panel
			}
		}
		
		return nil
	}
	
	var panelPinnedRight: PanelViewController? {
		
		for panel in panels {
			if panel?.pinnedSide == .right {
				return panel
			}
		}
		
		return nil
	}
	
	
	func pinnedPanelFrame(for panel: PanelViewController, at side: PanelPinSide) -> CGRect? {
		
		guard let panelView = panel.view else {
			return nil
		}
		
		var previewTargetFrame = panelView.bounds
		
		previewTargetFrame.origin.y = 0.0
		
		switch side {
		case .left:
			previewTargetFrame.origin.x = 0.0
		case .right:
			previewTargetFrame.origin.x = panelContentWrapperView.bounds.width - panelView.bounds.width
		}
		
		previewTargetFrame.size.height = panelContentWrapperView.bounds.height - previewTargetFrame.origin.y
		
		return previewTargetFrame
	}
	
	var panelGrowDuration: Double {
		return 0.3
	}
	
	func updatedContentViewFrame() -> CGRect {
		
		var updatedContentViewFrame = panelContentView.frame
		
		updatedContentViewFrame.size.width = panelContentWrapperView.bounds.width
		
		updatedContentViewFrame.origin.x = 0.0
		
		
		if let leftPanelSize = panelPinnedLeft?.contentViewController?.contentSize() {
			
			updatedContentViewFrame.size.width -= leftPanelSize.width
			
			updatedContentViewFrame.origin.x = leftPanelSize.width
		}
		
		if let rightPanelSize = panelPinnedRight?.contentViewController?.contentSize() {
			
			updatedContentViewFrame.size.width -= rightPanelSize.width
			
		}
		
		return updatedContentViewFrame
	}
	
	func fadePanelPinnedPreviewOut() {
		
		if let panelPinnedPreviewView = panelPinnedPreviewView {
			
			UIView.animate(withDuration: 0.3, animations: {
				panelPinnedPreviewView.alpha = 0.0
			}, completion: { (completed) in
				panelPinnedPreviewView.removeFromSuperview()
			})
			
			self.panelPinnedPreviewView = nil
		}
		
	}
	
}

// MARK: -

public extension PanelManager where Self: UIViewController {
	
	func didDragFree(_ panel: PanelViewController) {
		
		fadePanelPinnedPreviewOut()
		
		guard panel.isPinned else {
			return
		}
		
		guard let panelView = panel.view else {
			return
		}
		
		panel.pinnedSide = nil
		
		let currentFrame = panelView.frame
		
		var newFrame = currentFrame
		if let contentSize = panel.contentViewController?.contentSize() {
			newFrame.size = contentSize
		}
		
		panel.enableCornerRadius(animated: true, duration: panelGrowDuration)
		
		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			panel.enableShadow()
			
			self.panelContentView.frame = self.updatedContentViewFrame()
			
			self.didUpdatePinnedPanels()
			
		}) { (completed) in
			
			
		}
		
		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			panelView.frame = newFrame
			
		}) { (completed) in
			
			
		}
		
	}
	
	func dragAreaInsets(for panel: PanelViewController) -> UIEdgeInsets {
		
		let left = panelPinnedLeft?.view?.bounds.width ?? 0.0
		let right = panelPinnedRight?.view?.bounds.width ?? 0.0
		
		return UIEdgeInsets(top: 0.0, left: left, bottom: 0.0, right: right)
	}
	
	func didDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {
		
		guard allowPanelPinning else {
			return
		}
		
		guard !panel.isPinned else {
			return
		}
		
		if let _ = panelPinnedPreviewView {
			return
		}
		
		print("did drag \(panel) to edge of \(side) side")
		
		guard let panelView = panel.view else {
			return
		}
		
		let previewView = UIView(frame: panelView.frame)
		previewView.isUserInteractionEnabled = false
		
		guard let previewTargetFrame = pinnedPanelFrame(for: panel, at: side) else {
			return
		}
		
		previewView.backgroundColor = panel.tintColor
		previewView.alpha = 0.4
		
		panelContentWrapperView.addSubview(previewView)
		panelContentWrapperView.insertSubview(previewView, belowSubview: panelView)
		
		UIView.animate(withDuration: 0.3) {
			
			previewView.frame = previewTargetFrame
			
		}
		
		panelPinnedPreviewView = previewView
	}
	
	func didEndDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {
		
		fadePanelPinnedPreviewOut()
		
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
		
		panelView.removeFromSuperview()
		panelContentWrapperView.addSubview(panelView)
		
		panel.contentViewController?.setAutoResizingMask()
		
		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			panel.disableShadow()
			
			panelView.frame = frame
			
			self.panelContentView.frame = self.updatedContentViewFrame()
			
			self.didUpdatePinnedPanels()
			self.moveAllPanelsToValidPositions()
			
		}) { (completed) in
			
			
		}
		
	}
	
	func didEndDragFree(_ panel: PanelViewController) {
		
		fadePanelPinnedPreviewOut()
		
		guard panel.isPinned else {
			return
		}
		
		panel.pinnedSide = nil
		
	}
	
}

// MARK: -

public extension PanelManager where Self: UIViewController {
	
	func panelsPrepareMoveOffScreen() {
		
		for panel in panels {
			panel?.contentViewController?.prepareMoveOffScreen()
		}
		
	}
	
	func panelsPrepareMoveOnScreen() {
		
		for panel in panels {
			panel?.contentViewController?.prepareMoveOnScreen()
		}
		
	}
	
	func panelsMovePanelOnScreen() {
		
		for panel in panels {
			
			guard panel?.isShownAsPanel == true else {
				continue
			}
			
			panel?.contentViewController?.movePanelOnScreen()
			
		}
		
	}
	
	func panelsMovePanelOffScreen() {
		
		for panel in panels {
			
			guard panel?.isShownAsPanel == true else {
				continue
			}
			
			panel?.contentViewController?.movePanelOffScreen()
		}
		
	}
	
	func panelsCompleteMoveOnScreen() {
		
		for panel in panels {
			panel?.contentViewController?.completeMoveOnScreen()
		}
		
	}
	
	func panelsCompleteMoveOffScreen() {
		
		for panel in panels {
			panel?.contentViewController?.completeMoveOffScreen()
		}
		
	}
	
}
