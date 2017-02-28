//
//  PanelNavigationController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 10/09/16.
//  Copyright © 2016 Silver Fox. All rights reserved.
//

import UIKit

@objc public class PanelNavigationController: UINavigationController, UIGestureRecognizerDelegate {

	private var prevTouch: CGPoint?
	public weak var panelViewController: PanelViewController?

    override public func viewDidLoad() {
        super.viewDidLoad()

		let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragView(_ :)))

		self.view.addGestureRecognizer(dragGestureRecognizer)

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBar(_ :)))
		tapGestureRecognizer.delegate = self
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)

    }

	deinit {
		if panelViewController?.logLevel == .full {
			print("deinit \(self)")
		}
	}

	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	var dragInsets: UIEdgeInsets {
		if let panelViewController = self.panelViewController {
			return self.panelViewController?.delegate?.totalDragInsets(for: panelViewController) ?? .zero
		}

		return .zero
	}

	@objc private func didTapBar(_ gestureRecognizer: UITapGestureRecognizer) {

		if self.panelViewController?.isPinned != true {
			self.panelViewController?.bringToFront()
		}

	}

	@objc private func dragView(_ gestureRecognizer: UIPanGestureRecognizer) {

		if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {

			prevTouch = nil
			panelViewController?.didEndDrag()
			return

		}

		guard let panel = panelViewController else {
			return
		}

		guard panel.isFloating || panel.isPinned else {
			return
		}

		guard let viewToMove = panel.view else {
			return
		}

		guard let superview = viewToMove.superview else {
			return
		}

		if gestureRecognizer.numberOfTouches == 0 {
			return
		}

		let touch = gestureRecognizer.location(ofTouch: 0, in: superview)

		if gestureRecognizer.state == .began {

			prevTouch = touch

		}

		if gestureRecognizer.state == .changed {

			guard let prevTouch = prevTouch else {
				self.prevTouch = touch
				return
			}

			moveWithTouch(from: prevTouch, to: touch)
		}

	}

	func moveWithTouch(from fromTouch: CGPoint, to touch: CGPoint) {

		guard let panelViewController = self.panelViewController else {
			return
		}

		guard let viewToMove = self.panelViewController?.view else {
			return
		}

		let proposeX = viewToMove.center.x - (fromTouch.x - touch.x)
		let proposeY = viewToMove.center.y - (fromTouch.y - touch.y)

		let proposedCenter = CGPoint(x: proposeX, y: proposeY)

		var newFrame = viewToMove.frame
		let newCenter = panelViewController.allowedCenter(for: proposedCenter)
		newFrame.center = newCenter

		panelViewController.delegate?.updateFrame(for: panelViewController, to: newFrame)

		self.prevTouch = touch

		if self.panelViewController?.isPinned != true {
			self.panelViewController?.bringToFront()
		}

		panelViewController.didDrag()

	}

}
