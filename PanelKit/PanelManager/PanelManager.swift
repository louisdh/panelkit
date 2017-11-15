//
//  PanelManager.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 11/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

/// The PanelManager protocol contains the necessary settings for letting
/// panels float and pin. It also contains callbacks for certain actions triggered by panels.
///
/// Typically the `PanelManager` protocol is implemented on a `UIViewController` subclass.
/// If not, you should specify the `managerViewController` property.
public protocol PanelManager: class {

	/// The ```UIViewController``` that manages the panels and contains
	/// ```panelContentWrapperView``` and ```panelContentView```.
	///
	/// When the PanelManager protocol is implemented on a `UIViewController` subclass
	/// this property returns "self" by default.
	var managerViewController: UIViewController { get }

	/// The panels to be managed.
	var panels: [PanelViewController] { get }

	/// Controls wether panels are allowed to float (be dragged around).
	/// If this property returns true: the panel will automatically provide a UIBarButtonItem
	/// to make itself float when shown in a popover, as well as a close button (to close itself) while it's floating.
	/// 
	/// The default implementation returns true if `panelContentWrapperView.bounds.width > 800`.
	var allowFloatingPanels: Bool { get	}

	/// Controls wether panels are allowed to be pinned to either the left or right side.
	/// The ```panelContentView``` is resized when a panel is pinned.
	///
	/// The default implementation returns true if `panelContentWrapperView.bounds.width > 800`.
	var allowPanelPinning: Bool { get }

	/// Controls the number of panels that may be pinned to a side.
	///
	/// The default implementation returns 1.
	/// - Parameter side: A side where panels can be pinned to.
	/// - Returns: Maximum number of panels that may be pinned to `side`.
	func maximumNumberOfPanelsPinned(at side: PanelPinSide) -> Int
	
	/// The view in which the panels may be dragged around.
	var panelContentWrapperView: UIView { get }

	/// The content view, which will be moved/resized when panels pin.
	var panelContentView: UIView { get }

	/// Default implementation is ```LogLevel.none```.
	var panelManagerLogLevel: LogLevel { get }

	/// This will be called when a panel is pinned or unpinned.
	/// The default implementation is an empty function.
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
	/// The default implementation is an empty function.
	func willEnterExpose()

	/// Called when exposé is about to be exited.
	/// The default implementation is an empty function.
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
