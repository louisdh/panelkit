//
//  PanelViewController+Dragging.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelViewController {

	func didDrag(at point: CGPoint) {

		guard isFloating || isPinned else {
			return
		}

		guard let manager = self.manager else {
			return
		}

		let panelContentView = manager.panelContentView

		if self.view.frame.maxX >= panelContentView.frame.maxX && !isPinned {

			manager.didDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= panelContentView.frame.minX && !isPinned {

			manager.didDrag(self, toEdgeOf: .left)

		} else {

			if let pinnedSide = pinnedMetadata?.side {
				if !isUnpinning {
					self.unpinningMetadata = UnpinningMetadata(side: pinnedSide)
				}
			}

			manager.didDragFree(self, from: point)

		}

	}

	func didEndDrag() {

		self.unpinningMetadata = nil

		guard isFloating || isPinned else {
			return
		}

		guard let manager = self.manager else {
			return
		}

		let panelContentView = manager.panelContentView

		if self.view.frame.maxX >= panelContentView.frame.maxX {

			manager.didEndDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= panelContentView.frame.minX {

			manager.didEndDrag(self, toEdgeOf: .left)

		} else {

			manager.didEndDragFree(self)

		}

	}

}
