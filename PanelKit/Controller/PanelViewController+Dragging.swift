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

		guard let containerWidth = self.view.superview?.bounds.size.width else {
			return
		}

		if self.view.frame.maxX >= containerWidth {

			manager?.didDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 {

			manager?.didDrag(self, toEdgeOf: .left)

		} else {

			manager?.didDragFree(self, from: point)

		}

	}

	func didEndDrag() {

		guard isFloating || isPinned else {
			return
		}

		guard let containerWidth = self.view.superview?.bounds.size.width else {
			return
		}

		if self.view.frame.maxX >= containerWidth {

			manager?.didEndDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 {

			manager?.didEndDrag(self, toEdgeOf: .left)

		} else {

			manager?.didEndDragFree(self)

		}

	}

}
