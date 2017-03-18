//
//  PanelManager.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

public protocol PanelManager: class {

	/// The ```UIViewController``` that manages the panels and contains
	/// ```panelContentWrapperView``` and ```panelContentView```.
	var managerViewController: UIViewController { get }
	
	/// The panels to be managed.
	var panels: [PanelViewController] { get }

	/// Allow floating panels
	var allowFloatingPanels: Bool { get	}

	/// Allow panels to pin to either the left or right side,
	/// resizing ```panelContentView``` when a panel is pinned.
	var allowPanelPinning: Bool { get }

	/// The view in which the panels may be dragged around.
	var panelContentWrapperView: UIView { get }

	/// The content view, which will be moved/resized when panels pin.
	var panelContentView: UIView { get }

	/// Default implementation is ```LogLevel.none```.
	var panelManagerLogLevel: LogLevel { get }

	/// This will be called when a panel is pinned or unpinned.
	func didUpdatePinnedPanels()

	/// Drag insets for panel.
	///
	/// E.g. a positive top inset will change the minimum y value
	/// a panel can be dragged to inside ```panelContentWrapperView```.
	///
	/// - Parameter panel: The panel for which to provide insets.
	/// - Returns: Edge insets.
	func dragInsets(for panel: PanelViewController) -> UIEdgeInsets

	/// Blur effect for content overlay view when exposé is active.
	var exposeOverlayBlurEffect: UIBlurEffect { get }

	/// Called when exposé is about to be entered.
	func willEnterExpose()

	/// Called when exposé is about to be exited.
	func willExitExpose()

}

// MARK: -

extension PanelManager {

	func totalDragInsets(for panel: PanelViewController) -> UIEdgeInsets {

		let insets = dragInsets(for: panel)

		let left = panelPinnedLeft?.view?.bounds.width ?? 0.0
		let right = panelPinnedRight?.view?.bounds.width ?? 0.0

		return UIEdgeInsets(top: insets.top, left: insets.left + left, bottom: insets.bottom, right: insets.right + right)

	}

}

// MARK: -

public extension PanelManager {

	/// E.g. to move after a panel pins
	func moveAllPanelsToValidPositions() {

		for panel in panels {

			guard panel.isFloating else {
				continue
			}

			var newPanelFrame = panel.view.frame
			newPanelFrame.center = panel.allowedCenter(for: newPanelFrame.center)

			updateFrame(for: panel, to: newPanelFrame)

		}

	}

}
