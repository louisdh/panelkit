//
//  PanelManager+Expose.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 24/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

private var exposeOverlayViewKey: UInt8 = 0
private var exposeOverlayTapRecognizerKey: UInt8 = 0
private var exposeEnterTapRecognizerKey: UInt8 = 0

extension PanelManager {

	var exposeOverlayView: UIVisualEffectView {
		get {
			return associatedObject(self, key: &exposeOverlayViewKey) {
				return UIVisualEffectView(effect: nil)
			}
		}
		set {
			associateObject(self, key: &exposeOverlayViewKey, value: newValue)
		}
	}

	var exposeOverlayTapRecognizer: BlockGestureRecognizer {
		get {
			return associatedObject(self, key: &exposeOverlayTapRecognizerKey) {

				let gestureRecognizer = UITapGestureRecognizer()

				let blockRecognizer = BlockGestureRecognizer(view: exposeOverlayView, recognizer: gestureRecognizer, closure: { [weak self] in

					if self?.isInExpose == true {
						self?.exitExpose()
					}
				})

				return blockRecognizer
			}
		}
		set {
			associateObject(self, key: &exposeOverlayTapRecognizerKey, value: newValue)
		}
	}

	var exposeEnterTapRecognizer: BlockGestureRecognizer {
		get {
			return associatedObject(self, key: &exposeEnterTapRecognizerKey) {

				let tapGestureRecognizer = UITapGestureRecognizer()
				tapGestureRecognizer.numberOfTapsRequired = 2
				tapGestureRecognizer.numberOfTouchesRequired = 3

				let blockRecognizer = BlockGestureRecognizer(view: panelContentWrapperView, recognizer: tapGestureRecognizer) { [weak self] in

					self?.toggleExpose()

				}

				return blockRecognizer
			}
		}
		set {
			associateObject(self, key: &exposeEnterTapRecognizerKey, value: newValue)
		}
	}

}

public extension PanelManager {

	func enableTripleTapExposeActivation() {

		_ = exposeEnterTapRecognizer

	}

	func toggleExpose() {

		if isInExpose {
			exitExpose()
		} else {
			enterExpose()
		}

	}

	var isInExpose: Bool {

		for panel in panels {
			if panel.isInExpose {
				return true
			}
		}

		return false
	}

	func enterExpose() {

		guard !isInExpose else {
			return
		}

		addExposeOverlayViewIfNeeded()

		let exposePanels = panels.filter { (p) -> Bool in
			return p.isPinned || p.isFloating
		}

		guard !exposePanels.isEmpty else {
			return
		}

		willEnterExpose()

		let (panelFrames, scale) = calculateExposeFrames(with: exposePanels)

		for panelFrame in panelFrames {
			panelFrame.panel.frameBeforeExpose = panelFrame.panel.view.frame
			updateFrame(for: panelFrame.panel, to: panelFrame.exposeFrame)
		}

		panelContentWrapperView.insertSubview(exposeOverlayView, aboveSubview: panelContentView)
		exposeOverlayView.isUserInteractionEnabled = true

		UIView.animate(withDuration: exposeEnterDuration, delay: 0.0, options: [], animations: {

			self.exposeOverlayView.effect = self.exposeOverlayBlurEffect

			self.panelContentWrapperView.layoutIfNeeded()

			for panelFrame in panelFrames {

				panelFrame.panel.view.transform = CGAffineTransform(scaleX: scale, y: scale)

			}

		})

		for panel in panels {
			panel.hideResizeHandle()
		}

	}

	func exitExpose() {

		guard isInExpose else {
			return
		}

		let exposePanels = panels.filter { (p) -> Bool in
			return p.isInExpose
		}

		guard !exposePanels.isEmpty else {
			return
		}

		willExitExpose()

		for panel in exposePanels {
			if let frameBeforeExpose = panel.frameBeforeExpose {
				updateFrame(for: panel, to: frameBeforeExpose)
				panel.frameBeforeExpose = nil
			}
		}

		exposeOverlayView.isUserInteractionEnabled = false

		UIView.animate(withDuration: exposeExitDuration, delay: 0.0, options: [], animations: {

			self.exposeOverlayView.effect = nil

			self.panelContentWrapperView.layoutIfNeeded()

			for panel in exposePanels {

				panel.view.transform = .identity

			}

		})

		for panel in panels {
			panel.showResizeHandleIfNeeded()
		}

	}

}

extension PanelManager {

	func addExposeOverlayViewIfNeeded() {

		if exposeOverlayView.superview == nil {

			exposeOverlayView.translatesAutoresizingMaskIntoConstraints = false

			panelContentWrapperView.addSubview(exposeOverlayView)
			panelContentWrapperView.insertSubview(exposeOverlayView, aboveSubview: panelContentView)

			exposeOverlayView.topAnchor.constraint(equalTo: panelContentView.topAnchor).isActive = true
			exposeOverlayView.bottomAnchor.constraint(equalTo: panelContentView.bottomAnchor).isActive = true
			exposeOverlayView.leadingAnchor.constraint(equalTo: panelContentWrapperView.leadingAnchor).isActive = true
			exposeOverlayView.trailingAnchor.constraint(equalTo: panelContentWrapperView.trailingAnchor).isActive = true

			exposeOverlayView.alpha = 1.0

			exposeOverlayView.isUserInteractionEnabled = false

			panelContentWrapperView.layoutIfNeeded()

			_ = exposeOverlayTapRecognizer
		}

	}

	func calculateExposeFrames(with panels: [PanelViewController]) -> ([PanelExposeFrame], CGFloat) {

		let panelFrames: [PanelExposeFrame] = panels.map { (p) -> PanelExposeFrame in
			return PanelExposeFrame(panel: p)
		}

		distribute(panelFrames)

		guard let unionFrame = unionRect(with: panelFrames) else {
			return (panelFrames, 1.0)
		}

		if panelManagerLogLevel == .full {
			print("[Exposé] unionFrame: \(unionFrame)")
		}

		for r in panelFrames {

			r.exposeFrame.origin.x -= unionFrame.origin.x
			r.exposeFrame.origin.y -= unionFrame.origin.y

		}

		var normalizedUnionFrame = unionFrame
		normalizedUnionFrame.origin.x = 0.0
		normalizedUnionFrame.origin.y = 0.0

		if panelManagerLogLevel == .full {
			print("[Exposé] normalizedUnionFrame: \(normalizedUnionFrame)")
		}

		var exposeContainmentFrame = panelContentView.frame
		exposeContainmentFrame.size.width = panelContentWrapperView.frame.width
		exposeContainmentFrame.origin.x = 0

		let padding: CGFloat = exposeOuterPadding

		let scale = min(1.0, min(((exposeContainmentFrame.width - padding) / unionFrame.width), ((exposeContainmentFrame.height - padding) / unionFrame.height)))

		if panelManagerLogLevel == .full {
			print("[Exposé] scale: \(scale)")
		}

		var scaledNormalizedUnionFrame = normalizedUnionFrame
		scaledNormalizedUnionFrame.size.width *= scale
		scaledNormalizedUnionFrame.size.height *= scale

		if panelManagerLogLevel == .full {
			print("[Exposé] scaledNormalizedUnionFrame: \(scaledNormalizedUnionFrame)")
		}

		for r in panelFrames {

			r.exposeFrame.origin.x *= scale
			r.exposeFrame.origin.y *= scale

			let width = r.exposeFrame.size.width
			let height = r.exposeFrame.size.height

			r.exposeFrame.origin.x -= width * (1.0 - scale) / 2
			r.exposeFrame.origin.y -= height * (1.0 - scale) / 2

			// Center

			r.exposeFrame.origin.x += (max(exposeContainmentFrame.width - scaledNormalizedUnionFrame.width, 0.0)) / 2.0
			r.exposeFrame.origin.y += (max(exposeContainmentFrame.height - scaledNormalizedUnionFrame.height, 0.0)) / 2.0
			r.exposeFrame.origin.y += exposeContainmentFrame.origin.y

		}

		return (panelFrames, scale)

	}

	func doFramesIntersect(_ frames: [PanelExposeFrame]) -> Bool {

		for r1 in frames {

			for r2 in frames {
				if r1 === r2 {
					continue
				}

				if numberOfIntersections(of: r1, with: [r2]) > 0 {
					return true
				}

			}

		}

		return false

	}

	func numberOfIntersections(of frame: PanelExposeFrame, with frames: [PanelExposeFrame]) -> Int {

		var intersections = 0

		let r1 = frame

		for r2 in frames {
			if r1 === r2 {
				continue
			}

			let r1InsetFrame = r1.exposeFrame.insetBy(dx: -exposePanelHorizontalSpacing, dy: -exposePanelVerticalSpacing)
			if r1InsetFrame.intersects(r2.exposeFrame) {
				intersections += 1
			}

		}

		return intersections
	}

	func unionRect(with frames: [PanelExposeFrame]) -> CGRect? {

		guard var rect = frames.first?.exposeFrame else {
			return nil
		}

		for r in frames {

			rect = rect.union(r.exposeFrame)

		}

		return rect

	}

	func distribute(_ frames: [PanelExposeFrame]) {

		var frames = frames

		var stack = [PanelExposeFrame]()

		while doFramesIntersect(frames) {

			let sortedFrames = frames.sorted(by: { (r1, r2) -> Bool in
				let n1 = numberOfIntersections(of: r1, with: frames)
				let n2 = numberOfIntersections(of: r2, with: frames)
				return n1 > n2
			})

			guard let mostIntersected = sortedFrames.first else {
				break
			}

			stack.append(mostIntersected)

			guard let index = frames.index(where: { (r) -> Bool in
				r === mostIntersected
			}) else {
				break
			}

			frames.remove(at: index)

		}

		while !stack.isEmpty {

			guard let last = stack.popLast() else {
				break
			}

			frames.append(last)

			guard let unionRect = self.unionRect(with: frames) else {
				break
			}

			let g = CGPoint(x: unionRect.midX, y: unionRect.midY)

			let deltaX = max(1.0, last.panel.view.center.x - g.x)
			let deltaY = max(1.0, last.panel.view.center.y - g.y)

			while numberOfIntersections(of: last, with: frames) > 0 {

				last.exposeFrame.origin.x += deltaX / 20.0
				last.exposeFrame.origin.y += deltaY / 20.0

			}

		}

	}

}

class PanelExposeFrame {

	let panel: PanelViewController
	var exposeFrame: CGRect

	init(panel: PanelViewController) {
		self.panel = panel
		self.exposeFrame = panel.view.frame
	}

}
