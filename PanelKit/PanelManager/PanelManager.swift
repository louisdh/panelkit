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
	
	/// Default implementation is ```LogLevel.none```
	var panelManagerLogLevel: LogLevel { get }
	
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
	
	var panelManagerLogLevel: LogLevel {
		return .none
	}
	
}

// MARK: -

extension PanelManager where Self: UIViewController {

	func close(_ panel: PanelViewController) {
		
		panel.view.removeFromSuperview()
		
		panel.contentViewController?.didUpdateFloatingState()
		
		if panel.isPinned {
			didDragFree(panel)
		}
	
	}
	
}

public extension PanelManager where Self: UIViewController {
	
	func closeAllPanels() {
		
		for panel in panels {
			
			guard let panelSuperview = panel.view.superview else {
				continue
			}
			
			guard panelSuperview == panelContentWrapperView else {
				continue
			}
			
			close(panel)
			
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
	
}

extension PanelManager where Self: UIViewController {
	
	var panelGrowDuration: Double {
		return 0.3
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

	/// Updates the panel's constraints to match the specified frame
	func updateFrame(for panel: PanelViewController, to frame: CGRect) {
		
		guard panel.view.superview == panelContentWrapperView else {
			return
		}
		
		if panel.widthConstraint == nil {
			panel.widthConstraint = panel.view.widthAnchor.constraint(equalToConstant: frame.width)
		}
		
		if panel.topConstraint == nil {
			panel.topConstraint = panel.view.topAnchor.constraint(equalTo: panelContentWrapperView.topAnchor, constant: 0.0)
		}
		
		if panel.bottomConstraint == nil {
			panel.bottomConstraint = panel.view.bottomAnchor.constraint(equalTo: panelContentWrapperView.bottomAnchor, constant: 0.0)
		}
		
		if panel.leadingConstraint == nil {
			panel.leadingConstraint = panel.view.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor, constant: 0.0)
		}
		
		if panel.trailingConstraint == nil {
			panel.trailingConstraint = panel.view.trailingAnchor.constraint(equalTo: panelContentWrapperView.trailingAnchor, constant: 0.0)
		}
		
		
		if panel.isPinned {
			
			panel.heightConstraint?.isActive = false
			panel.heightConstraint = panel.view.heightAnchor.constraint(equalTo: panelContentWrapperView.heightAnchor, multiplier: 1.0)
			panel.heightConstraint?.isActive = true
			
		} else {
			
			panel.heightConstraint?.isActive = false
			panel.heightConstraint = panel.view.heightAnchor.constraint(equalToConstant: frame.height)
			panel.heightConstraint?.isActive = true
			panel.heightConstraint?.constant = frame.height
			
		}
		
		
		panel.leadingConstraint?.constant = frame.origin.x
		panel.trailingConstraint?.constant = frame.maxX - panelContentWrapperView.bounds.maxX
		
		if frame.center.x > panelContentView.frame.center.x {
			
			panel.leadingConstraint?.isActive = false
			panel.trailingConstraint?.isActive = true

		} else {
		
			panel.leadingConstraint?.isActive = true
			panel.trailingConstraint?.isActive = false

		}
		
		
		panel.widthConstraint?.isActive = true
		panel.widthConstraint?.constant = frame.width
		
		
		panel.topConstraint?.constant = frame.origin.y
		panel.bottomConstraint?.constant = frame.maxY - panelContentWrapperView.bounds.maxY

		
		if frame.center.y > panelContentWrapperView.bounds.center.y {

			panel.topConstraint?.isActive = false
			panel.bottomConstraint?.isActive = true
			
		} else {
			
			panel.topConstraint?.isActive = true
			panel.bottomConstraint?.isActive = false
			
		}

	}

}

public extension PanelManager where Self: UIViewController {

	func toggleFloatStatus(for panel: PanelViewController) {
		
		let panelNavCon = panel.panelNavigationController
		
		if panel.contentViewController?.isFloating == true && !panelNavCon.isPresentedAsPopover {
						
			close(panel)

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
				
				
				if panel.view.superview == self.panelContentWrapperView {
					panel.contentViewController?.didUpdateFloatingState()
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
		panel.enableShadow(animated: true, duration: panelGrowDuration)

		updateFrame(for: panel, to: newFrame)

		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
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
		previewView.alpha = 0.4
		
		panelContentWrapperView.addSubview(previewView)
		panelContentWrapperView.insertSubview(previewView, belowSubview: panelView)
		
		UIView.animate(withDuration: 0.3) {
			
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

		// FIXME: not needed?
		panelView.removeFromSuperview()
		panelContentWrapperView.addSubview(panelView)
		
		
		self.moveAllPanelsToValidPositions()
		self.updateFrame(for: panel, to: frame)


		UIView.animate(withDuration: panelGrowDuration, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
			
			self.panelContentWrapperView.layoutIfNeeded()

			self.panelContentView.frame = self.updatedContentViewFrame()
			
			self.didUpdatePinnedPanels()
			
		}) { (completed) in
			
			// Send panel and preview view to back, so (shadows of) non-pinned panels are on top
			self.panelContentWrapperView.sendSubview(toBack: panelView)
			if let pinnedPreviewView = pinnedPreviewView {
				self.panelContentWrapperView.sendSubview(toBack: pinnedPreviewView)
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

