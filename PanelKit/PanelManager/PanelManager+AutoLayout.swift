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
		panelContentView.bottomAnchor.constraint(equalTo: panelContentWrapperView.bottomAnchor, constant: panelContentWrapperView.bounds.height - frame.maxY).isActive = true

		panelContentView.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor, constant: frame.origin.x).isActive = true

		panelContentView.trailingAnchor.constraint(equalTo: panelContentWrapperView.trailingAnchor, constant: frame.maxX - panelContentWrapperView.bounds.width).isActive = true

	}

	/// Updates the panel's constraints to match the specified frame
	func updateFrame(for panel: PanelViewController, to frame: CGRect, keyboardShown: Bool = false) {

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

		if panel.isPinned && !keyboardShown && !isInExpose {

			panel.heightConstraint?.isActive = false
			panel.heightConstraint = panel.view.heightAnchor.constraint(equalTo: panelContentView.heightAnchor, multiplier: 1.0)
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

		if panel.isPinned && !isInExpose {

			panel.topConstraint?.constant = panelContentView.frame.origin.y

		} else {

			panel.topConstraint?.constant = frame.origin.y

		}

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
