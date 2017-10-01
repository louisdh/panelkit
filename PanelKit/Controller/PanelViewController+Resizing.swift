//
//  PanelViewController+Resizing.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 08/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

extension PanelViewController {
	
	@objc func pinchToResize(_ recognizer: UIPinchGestureRecognizer) {
		
		guard isResizing else {
			return
		}
		
		if recognizer.state == .began {

			scaleStartFrame = self.view.frame
			
		} else if let scaleStartFrame = scaleStartFrame {
			
			let pivotPoint = recognizer.location(in: self.view)
			
			var newFrame = scaleStartFrame
			newFrame.size.width *= recognizer.scale
			newFrame.size.height *= recognizer.scale
			
			let widthDelta = scaleStartFrame.size.width - newFrame.size.width
			let heightDelta = scaleStartFrame.size.height - newFrame.size.height
			
			let pivotPercentageX = pivotPoint.x / newFrame.size.width
			let pivotPercentageY = pivotPoint.y / newFrame.size.height

			newFrame.origin.x += pivotPercentageX * widthDelta
			newFrame.origin.y += pivotPercentageY * heightDelta
			
			delegate?.updateFrame(for: self, to: newFrame)
		
		}
		
	}
	
	@objc func dragLeftHandle(_ recognizer: UIPanGestureRecognizer) {
		
		if recognizer.state == .changed {
			
			let location = recognizer.location(in: self.view)
			
			var newFrame = self.view.frame
			newFrame.origin.x += location.x
			newFrame.size.width -= location.x
			
			delegate?.updateFrame(for: self, to: newFrame)
			
		}
		
	}
	
	@objc func dragRightHandle(_ recognizer: UIPanGestureRecognizer) {
		
		if recognizer.state == .changed {

			let location = recognizer.location(in: self.view)
			
			var newFrame = self.view.frame
			newFrame.size.width += (location.x - newFrame.width)
			
			delegate?.updateFrame(for: self, to: newFrame)
				
		}
	}
	
	@objc func dragTopHandle(_ recognizer: UIPanGestureRecognizer) {
		
		if recognizer.state == .changed {

			let location = recognizer.location(in: self.view)
			
			var newFrame = self.view.frame
			newFrame.origin.y += location.y
			newFrame.size.height -= location.y
			
			delegate?.updateFrame(for: self, to: newFrame)
			
		}
	}
	
	@objc func dragBottomHandle(_ recognizer: UIPanGestureRecognizer) {
		
		if recognizer.state == .changed {

			let location = recognizer.location(in: self.view)
			
			var newFrame = self.view.frame
			newFrame.size.height += (location.y - newFrame.height)
			
			delegate?.updateFrame(for: self, to: newFrame)
			
		}
	}
	
	static func handleContainer(for orientation: HandleViewOrientation) -> HandleContainer {
		
		let handleViewWrapper = UIView()
		handleViewWrapper.translatesAutoresizingMaskIntoConstraints = false
		
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.alignment = .center
		
		switch orientation {
		case .horizontal:
			stackView.axis = .vertical
			
		case .vertical:
			stackView.axis = .horizontal
			
		}
		
		handleViewWrapper.addSubview(stackView)
		
		handleViewWrapper.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1.0).isActive = true
		handleViewWrapper.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0).isActive = true
		handleViewWrapper.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
		handleViewWrapper.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
		
		let handleView = HandleView()
		handleView.orientation = orientation
		handleView.translatesAutoresizingMaskIntoConstraints = false
//		handleView.alpha = 0.5
//		handleView.contentMode = .redraw
		
		stackView.addArrangedSubview(handleView)
		
		let container = HandleContainer(wrapperView: handleViewWrapper, handleView: handleView)
		return container
	}
	
}
