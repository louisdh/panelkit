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
	
	var isPresentedAsPopover: Bool {
		get {
			
			if let p = self.popoverPresentationController {
				
				// FIXME: presentedViewController can never be nil?
				let c = p.presentedViewController as UIViewController?
				
				return c != nil && p.arrowDirection != .unknown
				
			} else {
				
				return false
				
			}
			
		}
	}
	
}
