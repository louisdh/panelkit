//
//  PanelsFullscreenTransitionDelegate.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

public protocol PanelsFullscreenTransitionDelegate {
	
	func panelsPrepareMoveOffScreen()
	func panelsPrepareMoveOnScreen()
	
	func panelsMovePanelOnScreen()
	func panelsMovePanelOffScreen()
	
	func panelsCompleteMoveOnScreen()
	func panelsCompleteMoveOffScreen()
	
}
