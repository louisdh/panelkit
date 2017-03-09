//
//  PanelViewController+Dragging.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelViewController {

	func didDrag() {

		guard isFloating || isPinned else {
			return
		}

		guard let containerWidth = self.view.superview?.bounds.size.width else {
			return
		}

		if self.view.frame.maxX >= containerWidth {

			delegate?.didDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 {

			delegate?.didDrag(self, toEdgeOf: .left)

		} else {

			delegate?.didDragFree(self)

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

			delegate?.didEndDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 {

			delegate?.didEndDrag(self, toEdgeOf: .left)

		} else {

			delegate?.didEndDragFree(self)

		}

	}

}
