//
//  PanelContentDelegate.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

public protocol PanelContentDelegate: class {

	var closeButtonTitle: String { get }
	var popButtonTitle: String { get }
	var modalCloseButtonTitle: String { get }

	var shouldAdjustForKeyboard: Bool { get }

	var preferredPanelContentSize: CGSize { get }

	func updateConstraintsForKeyboardShow(with frame: CGRect)

	func updateUIForKeyboardShow(with frame: CGRect)

	func updateConstraintsForKeyboardHide()

	func updateUIForKeyboardHide()

	/// Excludes potential "close" or "pop" buttons
	var leftBarButtonItems: [UIBarButtonItem] { get }

	/// Excludes potential "close" or "pop" buttons
	var rightBarButtonItems: [UIBarButtonItem] { get }

	func updateNavigationButtons()

}
