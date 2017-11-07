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
		
		guard let panelContentView = self.manager?.panelContentView else {
			return
		}
		
		let containerWidth: CGFloat
		
		if self.isPinned {
			
			guard let superview = self.view.superview else {
				return
			}
			
			containerWidth = superview.bounds.size.width
			
		} else {
			containerWidth = panelContentView.bounds.size.width
		}

		if self.view.frame.maxX >= containerWidth && !isPinned {

			manager?.didDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 && !isPinned {

			manager?.didDrag(self, toEdgeOf: .left)

		} else {

			if let pinnedSide = pinnedSide?.side {
				if !isUnpinning {
					self.unpinningMetadata = UnpinningMetadata(side: pinnedSide)
				}
			}
			
			manager?.didDragFree(self, from: point)

		}

	}

	func didEndDrag() {

		self.unpinningMetadata = nil

		guard isFloating || isPinned else {
			return
		}

		guard let panelContentView = self.manager?.panelContentView else {
			return
		}
		
		let containerWidth = panelContentView.bounds.size.width

//		guard let containerWidth = self.view.superview?.bounds.size.width else {
//			return
//		}

		if self.view.frame.maxX >= containerWidth {

			manager?.didEndDrag(self, toEdgeOf: .right)

		} else if self.view.frame.minX <= 0 {

			manager?.didEndDrag(self, toEdgeOf: .left)

		} else {

			manager?.didEndDragFree(self)

		}

	}

}
