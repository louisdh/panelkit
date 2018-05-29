//
//  PanelManager+AutoLayout.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelManager {

	func updateContentViewFrame(to frame: CGRect) {

		// First remove constraints that will be recreated

		var constraintsToCheck = [NSLayoutConstraint]()
		constraintsToCheck.append(contentsOf: panelContentWrapperView.constraints)
		constraintsToCheck.append(contentsOf: panelContentView.constraints)

		for c in constraintsToCheck {

			if (c.firstItem === panelContentView && c.secondItem === panelContentWrapperView) ||
				(c.secondItem === panelContentView && c.firstItem === panelContentWrapperView) {

				if panelContentView.constraints.contains(c) {
					panelContentView.removeConstraint(c)
				} else if panelContentWrapperView.constraints.contains(c) {
					panelContentWrapperView.removeConstraint(c)
				}

			}

		}

		// Recreate them

		panelContentView.topAnchor.constraint(equalTo: panelContentWrapperView.topAnchor, constant: frame.origin.y).isActive = true
		panelContentView.bottomAnchor.constraint(equalTo: panelContentWrapperView.bottomAnchor, constant: frame.maxY - panelContentWrapperView.bounds.height).isActive = true

		panelContentView.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor, constant: frame.origin.x).isActive = true

		panelContentView.trailingAnchor.constraint(equalTo: panelContentWrapperView.trailingAnchor, constant: frame.maxX - panelContentWrapperView.bounds.width).isActive = true

	}

	/// Updates the panel's constraints to match the specified frame
	func updateFrame(for panel: PanelViewController, to frame: CGRect, keyboardShown: Bool = false) {

		guard panel.view.superview == panelContentWrapperView else {
			return
		}

		if panel.topConstraint == nil {
			panel.topConstraint = panel.view.topAnchor.constraint(equalTo: panelContentWrapperView.topAnchor, constant: 0.0)
		}

		if panel.bottomConstraint == nil {
			panel.bottomConstraint = panel.view.bottomAnchor.constraint(equalTo: panelContentWrapperView.bottomAnchor, constant: 0.0)
		}

		panel.leadingConstraint?.isActive = false
		panel.leadingConstraint = panel.view.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor, constant: 0.0)

		panel.trailingConstraint?.isActive = false
		panel.trailingConstraint = panel.view.trailingAnchor.constraint(equalTo: panelContentWrapperView.trailingAnchor, constant: 0.0)

		if let pinnedSide = panel.pinnedMetadata?.side, !keyboardShown && !isInExpose {

			if pinnedSide == .left || pinnedSide == .right {
				
				panel.heightConstraint?.isActive = false
				
				let insets = dragInsets(for: panel)

				let multiplier = 1.0 / CGFloat(numberOfPanelsPinned(at: pinnedSide))
				panel.heightConstraint = panel.view.heightAnchor.constraint(equalTo: panelContentWrapperView.heightAnchor, multiplier: multiplier, constant: -insets.top - insets.bottom)
				panel.heightConstraint?.isActive = true
				
				panel.widthConstraint?.isActive = true
				panel.widthConstraint?.constant = frame.width
				
			} else {
				
				panel.widthConstraint?.isActive = false
				
				let multiplier = 1.0 / CGFloat(numberOfPanelsPinned(at: pinnedSide))
				panel.widthConstraint = panel.view.widthAnchor.constraint(equalTo: panelContentView.widthAnchor, multiplier: multiplier)
				panel.widthConstraint?.isActive = true
				
				panel.heightConstraint?.isActive = true
				panel.heightConstraint?.constant = frame.height
			}

		} else {

			panel.heightConstraint?.isActive = false
			panel.heightConstraint = panel.view.heightAnchor.constraint(equalToConstant: frame.height)
			panel.heightConstraint?.isActive = true
			panel.heightConstraint?.constant = frame.height
			
			panel.widthConstraint?.isActive = false
			panel.widthConstraint = panel.view.widthAnchor.constraint(equalToConstant: frame.width)
			panel.widthConstraint?.isActive = true
			panel.widthConstraint?.constant = frame.width

		}
		
		if let pinnedMetadata = panel.pinnedMetadata, pinnedMetadata.side == .top || pinnedMetadata.side == .bottom {

			panel.topConstraint?.constant = frame.origin.y
			panel.bottomConstraint?.constant = frame.maxY - panelContentWrapperView.bounds.maxY
			
			if frame.center.y > panelContentView.frame.center.y {
				
				panel.topConstraint?.isActive = false
				panel.bottomConstraint?.isActive = true
				
			} else {
				
				panel.topConstraint?.isActive = true
				panel.bottomConstraint?.isActive = false
				
			}
			
			var useLeadingConstraint = false
			
			if pinnedMetadata.index > 0, !keyboardShown {
				
				var panelsPinned = self.panelsPinned(at: pinnedMetadata.side).sorted { (p1, p2) -> Bool in
					return p1.pinnedMetadata?.index ?? 0 < p2.pinnedMetadata?.index ?? 0
				}
				
				let panelPinnedLeft = panelsPinned[pinnedMetadata.index - 1]
				
				assert(panelPinnedLeft != panel, "Panel logic error")
				
				panel.leadingConstraint?.isActive = false
				panel.leadingConstraint = panel.view.leadingAnchor.constraint(equalTo: panelPinnedLeft.view.trailingAnchor, constant: 0.0)
				
				useLeadingConstraint = true
				
			} else {
				
				panel.leadingConstraint?.isActive = false
				panel.leadingConstraint = panel.view.leadingAnchor.constraint(equalTo: panelContentView.leadingAnchor, constant: 0.0)
				
				if let pinnedSide = panel.pinnedMetadata?.side, numberOfPanelsPinned(at: pinnedSide) == 1, !isInExpose {
					
					panel.leadingConstraint?.constant = 0
					
				} else {
					
					panel.leadingConstraint?.constant = 0
					
				}
				
				if pinnedMetadata.side == .bottom, !keyboardShown {
					
					panel.bottomConstraint?.isActive = false
					panel.bottomConstraint = panel.view.bottomAnchor.constraint(equalTo: panelContentWrapperView.bottomAnchor, constant: 0.0)
					panel.topConstraint?.isActive = false
					panel.bottomConstraint?.isActive = true
					
				}
				
			}
			
			panel.trailingConstraint?.constant = frame.maxX - panelContentWrapperView.bounds.maxX
			
			if !useLeadingConstraint && frame.center.x > panelContentWrapperView.bounds.center.x {
				
				panel.leadingConstraint?.isActive = false
				panel.trailingConstraint?.isActive = true
				
			} else {
				
				panel.leadingConstraint?.isActive = true
				panel.trailingConstraint?.isActive = false
				
			}
			
		} else {
			
			panel.leadingConstraint?.constant = frame.origin.x
			panel.trailingConstraint?.constant = frame.maxX - panelContentWrapperView.bounds.maxX
			
			if frame.center.x > panelContentView.frame.center.x {
				
				panel.leadingConstraint?.isActive = false
				panel.trailingConstraint?.isActive = true
				
			} else {
				
				panel.leadingConstraint?.isActive = true
				panel.trailingConstraint?.isActive = false
				
			}
			
			var useTopConstraint = false
			
			if let pinnedMetadata = panel.pinnedMetadata, pinnedMetadata.index > 0, !keyboardShown {
				
				var panelsPinned = self.panelsPinned(at: pinnedMetadata.side).sorted { (p1, p2) -> Bool in
					return p1.pinnedMetadata?.index ?? 0 < p2.pinnedMetadata?.index ?? 0
				}
				
				let panelPinnedAbove = panelsPinned[pinnedMetadata.index - 1]
				
				assert(panelPinnedAbove != panel, "Panel logic error")
				
				panel.topConstraint?.isActive = false
				panel.topConstraint = panel.view.topAnchor.constraint(equalTo: panelPinnedAbove.view.bottomAnchor, constant: 0.0)
				
				useTopConstraint = true
				
			} else {
				
				panel.topConstraint?.isActive = false
				panel.topConstraint = panel.view.topAnchor.constraint(equalTo: panelContentWrapperView.topAnchor, constant: 0.0)
				
				if let pinnedSide = panel.pinnedMetadata?.side, numberOfPanelsPinned(at: pinnedSide) == 1, !isInExpose {
					
					panel.topConstraint?.constant = 0
					
				} else {
					
					panel.topConstraint?.constant = frame.origin.y
					
				}
				
			}
			
			panel.bottomConstraint?.constant = frame.maxY - panelContentWrapperView.bounds.maxY
			
			if !useTopConstraint && frame.center.y > panelContentWrapperView.bounds.center.y {
				
				panel.topConstraint?.isActive = false
				panel.bottomConstraint?.isActive = true
				
			} else {
				
				panel.topConstraint?.isActive = true
				panel.bottomConstraint?.isActive = false
				
			}

		}
		
	}

}
