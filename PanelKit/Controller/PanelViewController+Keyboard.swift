//
//  PanelViewController+Keyboard.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

extension PanelViewController {

	func keyboardWillChangeFrame(_ notification: Notification) {

	}

	func willShowKeyboard(_ notification: Notification) {

		guard let contentDelegate = contentDelegate else {
			return
		}

		guard contentDelegate.shouldAdjustForKeyboard else {
			return
		}

		guard let userInfo = notification.userInfo else {
			return
		}

		let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
		let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)

		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

		guard var keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			return
		}

		guard let viewToMove = self.view else {
			return
		}

		guard let superView = viewToMove.superview else {
			return
		}

		var keyboardFrameInSuperView = superView.convert(keyboardFrame, from: nil)
		keyboardFrameInSuperView = keyboardFrameInSuperView.intersection(superView.bounds)

		keyboardFrame = viewToMove.convert(keyboardFrame, from: nil)
		keyboardFrame = keyboardFrame.intersection(viewToMove.bounds)

		if isFloating || isPinned {

			if keyboardFrame.intersects(viewToMove.bounds) {

				let maxHeight = superView.bounds.height - keyboardFrameInSuperView.height

				let height = min(viewToMove.frame.height, maxHeight)

				let y = keyboardFrameInSuperView.origin.y - height

				let updatedFrame = CGRect(x: viewToMove.frame.origin.x, y: y, width: viewToMove.frame.width, height: height)

				delegate?.updateFrame(for: self, to: updatedFrame, keyboardShown: true)

				UIView.animate(withDuration: duration, delay: 0.0, options: [animationCurve], animations: {

					self.delegate?.panelContentWrapperView.layoutIfNeeded()

				}, completion: nil)

			}

		}

		contentDelegate.updateConstraintsForKeyboardShow(with: keyboardFrame)

		UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: {

			self.view.layoutIfNeeded()
			contentDelegate.updateUIForKeyboardShow(with: keyboardFrame)

		}, completion: nil)

	}

	func willHideKeyboard(_ notification: Notification) {

		guard let contentDelegate = contentDelegate else {
			return
		}

		guard let viewToMove = self.view else {
			return
		}

		guard let userInfo = notification.userInfo else {
			return
		}

		let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
		let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)

		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

		let currentFrame = viewToMove.frame

		// Currently uses a slight hack to prevent navigation bar height from bugging out (height became 64, instead of the normal 44)

		// 1: change panel size height to actual height + 1

		var newFrame = currentFrame
		newFrame.size = contentDelegate.preferredPanelContentSize
		newFrame.size.height += 1

		self.delegate?.updateFrame(for: self, to: newFrame, keyboardShown: true)

		contentDelegate.updateConstraintsForKeyboardHide()

		UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: {

			self.view.layoutIfNeeded()

			self.delegate?.panelContentWrapperView.layoutIfNeeded()

			contentDelegate.updateUIForKeyboardHide()

		}, completion: nil)

		// 2: change panel size height to actual height

		var newFrame2 = currentFrame
		newFrame2.size = contentDelegate.preferredPanelContentSize

		self.delegate?.updateFrame(for: self, to: newFrame2)
		self.delegate?.panelContentWrapperView.layoutIfNeeded()

	}

}
