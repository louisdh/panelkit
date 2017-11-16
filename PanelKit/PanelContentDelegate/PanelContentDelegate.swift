//
//  PanelContentDelegate.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

/// PanelContentDelegate determines the panel size and allows
/// you to get notified for certain events.
public protocol PanelContentDelegate: class {

	/// The title for the close button in the navigation bar.
	var closeButtonTitle: String { get }

	/// The title for the pop button in the navigation bar.
	/// This is the button that will make the panel float when tapped.
	var popButtonTitle: String { get }

	/// The close button title for the panel when it is presented modally.
	var modalCloseButtonTitle: String { get }

	/// Return true to make the panel manager resize the panel
	/// when a keyboard is shown.
	///
	/// Typically you would only want to return true when something
	/// in the panel is first responser.
	///
	/// Returns false by default.
	var shouldAdjustForKeyboard: Bool { get }

	/// The size the panel should have while floating.
	/// The panel manager will try to maintain the size specified by
	/// this property. The panel manager may deviate from this size,
	/// for example when the keyboard is shown.
	var preferredPanelContentSize: CGSize { get }

	/// The width the panel should have when it is pinned.
	///
	/// Returns `preferredPanelContentSize.width` by default.
	var preferredPanelPinnedWidth: CGFloat { get }

	/// The `minimumPanelContentSize` controls the minimum size
	/// a panel may have while floating.
	/// If this property differs from `preferredPanelContentSize`, it will
	/// allow the user to resize the panel.
	///
	/// Returns `preferredPanelContentSize` by default.
	var minimumPanelContentSize: CGSize { get }

	/// The `maximumPanelContentSize` controls the maximum size
	/// a panel may have while floating.
	/// If this property differs from `preferredPanelContentSize`, it will
	/// allow the user to resize the panel.
	///
	/// Returns `preferredPanelContentSize` by default.
	var maximumPanelContentSize: CGSize { get }

	/// Notifies you that the keyboard will be shown.
	/// Use this to update any constraints that descend from the panel's view.
	/// The constraints will be updated with an animation automatically.
	///
	/// - Parameter frame: the keyboard frame,
	/// in the panel's coordinate space.
	func updateConstraintsForKeyboardShow(with frame: CGRect)

	/// Notifies you that the keyboard will be shown.
	/// Use this to change any view frames (when not using Auto Layout).
	/// This function will be invoked in a UIView animation block.
	///
	/// - Parameter frame: the keyboard frame,
	/// in the panel's coordinate space.
	func updateUIForKeyboardShow(with frame: CGRect)

	/// Notifies you that the keyboard will hide.
	/// Use this to update any constraints that descend from the panel's view.
	/// The constraints will be updated with an animation automatically.
	func updateConstraintsForKeyboardHide()

	/// Notifies you that the keyboard will hide.
	/// Use this to change any view frames (when not using Auto Layout).
	/// This function will be invoked in a UIView animation block.
	func updateUIForKeyboardHide()

	/// Excludes potential "close" or "pop" buttons.
	/// Default implementation is an empty array.
	var leftBarButtonItems: [UIBarButtonItem] { get }

	/// Excludes potential "close" or "pop" buttons.
	/// Default implementation is an empty array.
	var rightBarButtonItems: [UIBarButtonItem] { get }

	/// This is called when the state of the panel changes.
	/// The default implementation provides the default close or pop button.
	/// Only implement yourself if you wish to use your own close and pop button.
	func updateNavigationButtons()

	/// Return true to make the drag gesture recognizer receive its touch.
	/// This is only applicable when a panel is in a floating state.
	/// Returning false will prevent the panel from being dragged.
	/// 
	/// This can be used to prevent the panel from dragging in certain areas.
	func panelDragGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool

}
