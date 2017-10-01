//
//  HandleView.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 06/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit

enum HandleViewOrientation: Int {
	case horizontal
	case vertical
}

class HandleView: UIView {

	var orientation: HandleViewOrientation = .horizontal
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		
		let effect = UIBlurEffect(style: .light)
		let visualEffectView = UIVisualEffectView(effect: effect)
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false

		self.addSubview(visualEffectView)
		
		visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		visualEffectView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		
		self.layer.cornerRadius = 2.0
		self.layer.masksToBounds = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//    override func draw(_ rect: CGRect) {
//		
//		let cornerRadius: CGFloat
//		
//		switch orientation {
//		case .horizontal:
//			cornerRadius = rect.height / 2
//			
//		case .vertical:
//			cornerRadius = rect.width / 2
//		}
//		
//		let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
//
//		UIColor.white.setFill()
//		
//		path.fill()
//		
//    }
	
	override var intrinsicContentSize: CGSize {
		switch orientation {
		case .horizontal:
			return CGSize(width: 44, height: 32)
			
		case .vertical:
			return CGSize(width: 32, height: 44)

		}
	}
	
//	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//		
//		let frame = self.bounds.insetBy(dx: -20, dy: -20)
//		
//		if frame.contains(point) {
//			return self
//		} else {
//			return nil
//		}
//	}
	
}
