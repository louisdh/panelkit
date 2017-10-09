//
//  PanelViewController+Offscreen.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelViewController {

	func prepareMoveOffScreen() {

		position = view?.center

	}

	func movePanelOffScreen() {

		guard let viewToMove = self.view else {
			return
		}

		guard let superView = viewToMove.superview else {
			return
		}

		let deltaToMoveOffscreen: CGFloat = viewToMove.frame.width + shadowRadius + max(0, -shadowOffset.width)

		var frame = viewToMove.frame

		if viewToMove.center.x < superView.frame.size.width/2.0 {
			frame.center = CGPoint(x: -deltaToMoveOffscreen, y: viewToMove.center.y)
		} else {
			frame.center = CGPoint(x: superView.frame.size.width + deltaToMoveOffscreen, y: viewToMove.center.y)
		}

		manager?.updateFrame(for: self, to: frame)

	}

	func completeMoveOffScreen() {

		positionInFullscreen = view?.center

	}

	// MARK: - Move on screen

	func prepareMoveOnScreen() {

		guard let position = position else {
			return
		}

		guard let positionInFullscreen = positionInFullscreen else {
			return
		}

		guard let viewToMove = self.view else {
			return
		}

		let x = position.x - (positionInFullscreen.x - viewToMove.center.x)
		let y = position.y - (positionInFullscreen.y - viewToMove.center.y)

		self.position = CGPoint(x: x, y: y)
	}

	func movePanelOnScreen() {

		guard let position = position else {
			return
		}

		guard let viewToMove = self.view else {
			return
		}

		var frame = viewToMove.frame
		frame.center = position

		manager?.updateFrame(for: self, to: frame)

	}

	func completeMoveOnScreen() {

	}

}
