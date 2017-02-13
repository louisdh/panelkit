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

	/// Default is false
	internal(set) var isShownAsPanel = false

    override public func viewDidLoad() {
        super.viewDidLoad()
		
		let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragOnBar(_ :)))
		
		self.navigationBar.addGestureRecognizer(dragGestureRecognizer)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBar(_ :)))
		tapGestureRecognizer.delegate = self
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)
		
    }
	
	deinit {
		print("deinit \(self)")
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	// TODO: get from delegate
	private let topYMin: CGFloat = 0.0
	private let touchYMin: CGFloat = 0.0

	var dragInsets: UIEdgeInsets {
		if let panelViewController = self.panelViewController {
			return self.panelViewController?.delegate?.dragAreaInsets(for: panelViewController) ?? .zero
		}
		
		return .zero
	}
	
	@objc private func didTapBar(_ gestureRecognizer: UITapGestureRecognizer) {

		bringToFront()
		
	}
	
	@objc private func dragOnBar(_ gestureRecognizer: UIPanGestureRecognizer) {
	
		if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
			
			prevTouch = nil
			panelViewController?.didEndDrag()
			return

		}
		
		guard isShownAsPanel else {
			return
		}
		
		guard let viewToMove = self.panelViewController?.view else {
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
//		viewToMove.center = panelViewController.allowedCenter(for: proposedCenter)
		
		self.prevTouch = touch
		
		// TODO: refactor
		(self.viewControllers.first as? PanelContentViewController)?.setAutoResizingMask()
		
		bringToFront()
		
		panelViewController.didDrag()
		
	}
	
	private func bringToFront() {
		
		guard let viewToMove = self.panelViewController?.view else {
			return
		}
		
		guard let superview = viewToMove.superview else {
			return
		}
		
		superview.bringSubview(toFront: viewToMove)

	}
	
	@objc public func setAsPanel(_ asPanel: Bool) {
		
		isShownAsPanel = asPanel
		
	}

	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if !isShownAsPanel {
			return
		}
		
		guard let viewToMove = self.panelViewController?.view else {
			return
		}
		
		guard let superview = viewToMove.superview else {
			return
		}
		
		guard let touch = touches.first?.location(in: superview) else {
			return
		}

		guard let prevTouch = prevTouch else {
			self.prevTouch = touch
			return
		}
		
		moveWithTouch(from: prevTouch, to: touch)

	}
	
	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		prevTouch = nil
		panelViewController?.didEndDrag()

	}
	
	override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		prevTouch = nil
		panelViewController?.didEndDrag()

	}
}
