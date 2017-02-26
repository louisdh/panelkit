//
//  PanelManager+Offscreen.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 13/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

public extension PanelManager where Self: UIViewController {

	func panelsPrepareMoveOffScreen() {

		for panel in panels {
			panel.contentViewController?.prepareMoveOffScreen()
		}

	}

	func panelsPrepareMoveOnScreen() {

		for panel in panels {
			panel.contentViewController?.prepareMoveOnScreen()
		}

	}

	func panelsMovePanelOnScreen() {

		for panel in panels {

			guard panel.isFloating || panel.isPinned else {
				continue
			}

			panel.contentViewController?.movePanelOnScreen()

		}

	}

	func panelsMovePanelOffScreen() {

		for panel in panels {

			guard panel.isFloating || panel.isPinned else {
				continue
			}

			panel.contentViewController?.movePanelOffScreen()
		}

	}

	func panelsCompleteMoveOnScreen() {

		for panel in panels {
			panel.contentViewController?.completeMoveOnScreen()
		}

	}

	func panelsCompleteMoveOffScreen() {

		for panel in panels {
			panel.contentViewController?.completeMoveOffScreen()
		}

	}

}
