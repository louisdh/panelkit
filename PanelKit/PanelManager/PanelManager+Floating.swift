//
//  PanelManager+Floating.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit


public extension PanelManager where Self: UIViewController {

	var managerViewController: UIViewController {
		return self
	}

}

public extension PanelManager {

	func toggleFloatStatus(for panel: PanelViewController, completion: (() -> Void)? = nil) {

		let panelNavCon = panel.panelNavigationController

		if (panel.isFloating || panel.isPinned) && !panelNavCon.isPresentedAsPopover {

			close(panel)
			completion?()

		} else {

			let rect = panel.view.convert(panel.view.frame, to: panelContentWrapperView)

			panel.dismiss(animated: false, completion: {

				self.panelContentWrapperView.addSubview(panel.view)
				
				panel.didUpdateFloatingState()

				self.updateFrame(for: panel, to: rect)
				self.panelContentWrapperView.layoutIfNeeded()

				let x = rect.origin.x
				let y = rect.origin.y + panelPopYOffset

				let width = panel.view.frame.size.width
				let height = panel.view.frame.size.height

				var newFrame = CGRect(x: x, y: y, width: width, height: height)
				newFrame.center = panel.allowedCenter(for: newFrame.center)

				self.updateFrame(for: panel, to: newFrame)

				UIView.animate(withDuration: panelPopDuration, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {

					self.panelContentWrapperView.layoutIfNeeded()

				}, completion: nil)

				if panel.view.superview == self.panelContentWrapperView {
					panel.contentDelegate?.didUpdateFloatingState()
				}

				completion?()

			})

		}

	}

}
