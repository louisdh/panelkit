//
//  PanelManager.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

public protocol PanelManager: PanelViewControllerDelegate, PanelsFullscreenTransitionDelegate, PanelContentViewControllerDelegate {
	
	var panels: [PanelViewController] { get }
	
	var allowFloatingPanels: Bool { get	}
	
	var allowPanelPinning: Bool { get }
		
	var panelContentWrapperView: UIView { get }
	
	var panelContentView: UIView { get }
	
	func didUpdatePinnedPanels()
	
}

// MARK: - Default implementation

public extension PanelManager where Self: UIViewController {

	func didUpdatePinnedPanels() {
		
	}
	
	func enablePanelShadow(for panel: PanelViewController) -> Bool {
		return true
	}

	var allowFloatingPanels: Bool {
		return panelContentWrapperView.bounds.width > 800
	}
	
	var allowPanelPinning: Bool {
		return panelContentWrapperView.bounds.width > 800
	}
	
}

// MARK: -

public extension PanelManager where Self: UIViewController {
	
	func closeAllPanels() {
		
		for panel in panels {
			
			guard let panelSuperview = panel.view.superview else {
				continue
			}
			
			guard panelSuperview == panelContentWrapperView else {
				continue
			}
			
			panel.view.removeFromSuperview()
			
			panel.contentViewController?.setAsPanel(false)
			
			if panel.isPinned {
				didDragFree(panel)
			}
			
		}
		
	}
	
	/// E.g. to move after a panel pins
	func moveAllPanelsToValidPositions() {
		
		for panel in panels {
			
			guard panel.isFloating else {
				continue
			}
			
			var newPanelFrame = panel.view.frame
			newPanelFrame.center = panel.allowedCenter(for: newPanelFrame.center)
			
			updateFrame(for: panel, to: newPanelFrame)
//			panel.view.center = panel.allowedCenter(for: panel.view.center)
			
		}
		
	}
	
	var panelPinnedLeft: PanelViewController? {
		
		for panel in panels {
			if panel.pinnedSide == .left {
				return panel
			}
		}
		
		return nil
	}
	
	var panelPinnedRight: PanelViewController? {
		
		for panel in panels {
			if panel.pinnedSide == .right {
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
		
		
		if let leftPanelSize = panelPinnedLeft?.contentViewController?.preferredPanelContentSize {
			
			updatedContentViewFrame.size.width -= leftPanelSize.width
			
			updatedContentViewFrame.origin.x = leftPanelSize.width
		}
		
		if let rightPanelSize = panelPinnedRight?.contentViewController?.preferredPanelContentSize {
			
			updatedContentViewFrame.size.width -= rightPanelSize.width
			
		}
		
		return updatedContentViewFrame
	}
	
	func fadePinnedPreviewOut(for panel: PanelViewController) {
		
		if let panelPinnedPreviewView = panel.panelPinnedPreviewView {
			
			UIView.animate(withDuration: 0.3, animations: {
				panelPinnedPreviewView.alpha = 0.0
			}, completion: { (completed) in
				panelPinnedPreviewView.removeFromSuperview()
			})
			
			panel.panelPinnedPreviewView = nil
		}
		
	}
	
}

// MARK: -

extension PanelManager {

	func updateFrame(for panel: PanelViewController, to frame: CGRect) {
		
		guard panel.view.superview == panelContentWrapperView else {
			return
		}
		
		if panel.widthConstraint == nil {
			panel.widthConstraint = panel.view.widthAnchor.constraint(equalToConstant: frame.width)
		}
		
		panel.widthConstraint?.isActive = true
		panel.widthConstraint?.constant = frame.width

		
		if panel.heightConstraint == nil {
			panel.heightConstraint = panel.view.heightAnchor.constraint(equalToConstant: frame.height)
		}

		
		panel.heightConstraint?.isActive = true
		panel.heightConstraint?.constant = frame.height

		
		if panel.topConstraint == nil {
			panel.topConstraint = panel.view.topAnchor.constraint(equalTo: panelContentWrapperView.topAnchor, constant: 0.0)
		}
			
		panel.topConstraint?.isActive = true
		panel.topConstraint?.constant = frame.origin.y
		
		
		if panel.leadingConstraint == nil {
			panel.leadingConstraint = panel.view.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor, constant: 0.0)
		}
		
		panel.leadingConstraint?.isActive = true
		panel.leadingConstraint?.constant = frame.origin.x
		
	}

}

public extension PanelManager where Self: UIViewController {

	func toggleFloatStatus(for panel: PanelViewController) {
		
		let panelNavCon = panel.panelNavigationController
		
		if panel.contentViewController?.isFloating == true && !panelNavCon.isPresentedAsPopover {
			
			panel.view.removeFromSuperview()
			
			panel.contentViewController?.setAsPanel(false)
			
		} else {
			
			let rect = panel.view.convert(panel.view.frame, to: panelContentWrapperView)
			
			panel.dismiss(animated: false, completion: {
				
				self.panelContentWrapperView.addSubview(panel.view)
								
				self.updateFrame(for: panel, to: rect)
				self.panelContentWrapperView.layoutIfNeeded()

				let x = rect.origin.x
				
				let y: CGFloat = 12.0
				
				let width = panel.view.frame.size.width
				let height = panel.view.frame.size.height
				
				var newFrame = CGRect(x: x, y: y, width: width, height: height)
				newFrame.center = panel.allowedCenter(for: newFrame.center)
				
				self.updateFrame(for: panel, to: newFrame)

				UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
					self.panelContentWrapperView.layoutIfNeeded()

					
				}, completion: nil)
				
				
				panel.contentViewController?.setAutoResizingMask()
				
				if panel.view.superview == self.panelContentWrapperView {
					panel.contentViewController?.setAsPanel(true)
					panelNavCon.setAsPanel(true)
				}
				
			})
			
		}
		
	}
}

public extension PanelManager where Self: UIViewController {
	
	func didDragFree(_ panel: PanelViewController) {
		
		fadePinnedPreviewOut(for: panel)
		
		guard panel.isPinned else {
			return
		}
		
		guard let panelView = panel.view else {
			return
		}
		
		panel.pinnedSide = nil
		
		let currentFrame = panelView.frame
		
		var newFrame = currentFrame
		if let contentSize = panel.contentViewController?.preferredPanelContentSize {
			newFrame.size = contentSize
		}
		
		panel.enableCornerRadius(animated: true, duration: panelGrowDuration)
		
		updateFrame(for: panel, to: newFrame)

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			panel.enableShadow()
			
			self.panelContentView.frame = self.updatedContentViewFrame()
			self.panelContentWrapperView.layoutIfNeeded()

			self.didUpdatePinnedPanels()
			
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
		
		if let _ = panel.panelPinnedPreviewView {
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
		
		panel.panelPinnedPreviewView = previewView
	}
	
	func didEndDrag(_ panel: PanelViewController, toEdgeOf side: PanelPinSide) {
		
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
		
		panelView.removeFromSuperview()
		panelContentWrapperView.addSubview(panelView)
		
		panel.contentViewController?.setAutoResizingMask()
		
		self.moveAllPanelsToValidPositions()
		self.updateFrame(for: panel, to: frame)

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			panel.disableShadow()
			
			self.panelContentWrapperView.layoutIfNeeded()

			self.panelContentView.frame = self.updatedContentViewFrame()
			
			self.didUpdatePinnedPanels()
			
		}) { (completed) in
			
			
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

