//
//  PanelManager+Offscreen.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 13/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

public extension PanelManager {

	func panelsPrepareMoveOffScreen() {

		for panel in panels {
			panel.prepareMoveOffScreen()
		}

	}

	func panelsPrepareMoveOnScreen() {

		for panel in panels {
			panel.prepareMoveOnScreen()
		}

	}

	func panelsMoveOnScreen() {

		for panel in panels {

			guard panel.isFloating || panel.isPinned else {
				continue
			}

			panel.movePanelOnScreen()

		}

	}

	func panelsMoveOffScreen() {

		for panel in panels {

			guard panel.isFloating || panel.isPinned else {
				continue
			}

			panel.movePanelOffScreen()
		}

	}

	func panelsCompleteMoveOnScreen() {

		for panel in panels {
			panel.completeMoveOnScreen()
		}

	}

	func panelsCompleteMoveOffScreen() {

		for panel in panels {
			panel.completeMoveOffScreen()
		}

	}

}
