//
//  UIViewController+Popover.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

	/// Returns true if the `UIViewController` instance is presented as a popover.
	@objc public var isPresentedAsPopover: Bool {

		// Checking for a "UIPopoverView" seems to be deemed trustworthy,
		// as explained here:
		// http://petersteinberger.com/blog/2015/uipresentationcontroller-popover-detection/

		var currentView: UIView? = self.view

		while currentView != nil {
			let classNameOfCurrentView = NSStringFromClass(type(of: currentView!)) as NSString

			let searchString = "UIPopoverView"

			if classNameOfCurrentView.range(of: searchString, options: .caseInsensitive).location != NSNotFound {
				return true
			}

			currentView = currentView?.superview
		}

		return false

		// The "popoverPresentationController" way of checking if presented as popover
		// causes a memory leak :/
		// Possibly because "popoverPresentationController" is lazily created?

//		guard let p = self.popoverPresentationController else {
//			return false
//		}
//
//		// FIXME: presentedViewController can never be nil?
//		let c = p.presentedViewController as UIViewController?
//
//		return c != nil && p.arrowDirection != .unknown

	}

}
