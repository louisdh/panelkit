//
//  PanelManager+Closing.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 08/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelManager {

	func close(_ panel: PanelViewController) {

		panel.view.removeFromSuperview()

		panel.contentDelegate?.didUpdateFloatingState()

		if panel.isPinned || panel.wasPinned {
			didDragFree(panel)
		}

	}

}

public extension PanelManager {

	func closeAllPinnedPanels() {

		for panel in panels {

			guard panel.view.superview == panelContentWrapperView else {
				continue
			}

			guard panel.isPinned || panel.wasPinned else {
				continue
			}

			close(panel)

		}

	}

	func closeAllFloatingPanels() {

		for panel in panels {

			guard panel.view.superview == panelContentWrapperView else {
				continue
			}

			guard panel.isFloating else {
				continue
			}

			close(panel)

		}

	}

}
