//
//  PanelViewController+States.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

extension PanelViewController {

	var wasPinned: Bool {
		return !isPinned && pinnedMetadata != nil
	}

	@objc public var isUnpinning: Bool {
		return unpinningMetadata != nil
	}

	@objc public var isPinned: Bool {

		if isPresentedAsPopover {
			return false
		}

		if isPresentedModally {
			return false
		}

		guard view.superview != nil else {
			return false
		}

		return pinnedMetadata != nil
	}

	@objc public var isFloating: Bool {

		if isPresentedAsPopover {
			return false
		}

		if isPresentedModally {
			return false
		}

		if isPinned {
			return false
		}

		guard view.superview != nil else {
			return false
		}

		return true
	}

	var isPresentedModally: Bool {

		if isPresentedAsPopover {
			return false
		}

		return presentingViewController != nil
	}

	public var isInExpose: Bool {
		return frameBeforeExpose != nil
	}

	/// A panel can't float when it is presented modally.
	public var canFloat: Bool {

		guard manager?.allowFloatingPanels == true else {
			return false
		}

		if isPresentedAsPopover {
			return true
		}

		// Modal
		if isPresentedModally {
			return false
		}

		return true
	}

}

// MARK: - State updating

extension PanelViewController {

	func updateState() {

		if wasPinned {
			manager?.didDragFree(self, from: view.frame.origin)
		}

		if isFloating || isPinned {
			self.view.translatesAutoresizingMaskIntoConstraints = false

			if !isPinned {
				enableCornerRadius()
				if shadowEnabled {
					enableShadow()
				}
			}

		} else {
			self.view.translatesAutoresizingMaskIntoConstraints = true

			disableShadow()
			disableCornerRadius()

		}

		contentDelegate?.updateNavigationButtons()

	}

	func didUpdateFloatingState() {

		updateState()

		self.updateShadow()

		if !(isFloating || isPinned) {
			widthConstraint?.isActive = false
			heightConstraint?.isActive = false
		}

		if isFloating {
			showResizeHandleIfNeeded()
		} else {
			hideResizeHandle()
		}

	}

}
