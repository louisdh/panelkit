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

	func toggleFloatStatus(for panel: PanelViewController, animated: Bool = true, completion: (() -> Void)? = nil) {

		let panelNavCon = panel.panelNavigationController

		if (panel.isFloating || panel.isPinned) && !panelNavCon.isPresentedAsPopover {

			close(panel)
			completion?()

		} else if panelNavCon.isPresentedAsPopover {

			let rect = panel.view.convert(panel.view.frame, to: panelContentWrapperView)

			panel.dismiss(animated: false, completion: {

				self.floatPanel(panel, toRect: rect, animated: animated)

				completion?()

			})

		} else {
			
			let rect = CGRect(origin: .zero, size: panel.preferredContentSize)
			floatPanel(panel, toRect: rect, animated: animated)
			
		}

	}
	
	internal func floatPanel(_ panel: PanelViewController, toRect rect: CGRect, animated: Bool) {
		
		self.panelContentWrapperView.addSubview(panel.resizeCornerHandle)
		
		self.panelContentWrapperView.addSubview(panel.view)
		
		panel.resizeCornerHandle.bottomAnchor.constraint(equalTo: panel.view.bottomAnchor, constant: 16).isActive = true
		panel.resizeCornerHandle.trailingAnchor.constraint(equalTo: panel.view.trailingAnchor, constant: 16).isActive = true
		
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
		
		if animated {
			
			UIView.animate(withDuration: panelPopDuration, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
				
				self.panelContentWrapperView.layoutIfNeeded()
				
			}, completion: nil)
			
		} else {
			
			self.panelContentWrapperView.layoutIfNeeded()

		}
		
		if panel.view.superview == self.panelContentWrapperView {
			panel.contentDelegate?.didUpdateFloatingState()
		}
		
	}

}

public extension PanelManager {
	
	func float(_ panel: PanelViewController, at frame: CGRect) {
		
		guard !panel.isFloating else {
			return
		}
		
		guard panel.canFloat else {
			return
		}
		
		toggleFloatStatus(for: panel, animated: false)
		
		updateFrame(for: panel, to: frame)
		
		self.panelContentWrapperView.layoutIfNeeded()

		panel.viewWillAppear(false)
		panel.viewDidAppear(false)
		
	}
	
}
