//
//  CornerHandleView.swift
//  HandleViewTest
//
//  Created by Louis D'hauwe on 01/10/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class CornerHandleView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)

		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

	private func setup() {

		let glyphView = CornerHandleGlyphView()
		glyphView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)

		glyphView.backgroundColor = .clear
		glyphView.isOpaque = false
		glyphView.tintColor = self.tintColor

        let drawRect = CGRect(origin: .zero, size: glyphView.bounds.size)
		UIGraphicsBeginImageContextWithOptions(drawRect.size, false, 0.0)

        if let context = UIGraphicsGetCurrentContext() {
            glyphView.draw(in: context, rect: drawRect)
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()

		self.tintColor = .white

		visualEffectView.translatesAutoresizingMaskIntoConstraints = false

		self.addSubview(visualEffectView)

		visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
		visualEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
		visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true

		self.widthAnchor.constraint(equalToConstant: 38).isActive = true
		self.heightAnchor.constraint(equalToConstant: 38).isActive = true

		let imgView = UIImageView(image: img)
		imgView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
		visualEffectView.mask = imgView

		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 8.0
		self.layer.shadowOpacity = 0.4
		self.layer.shadowOffset = .zero

		self.visualEffectView.transform = CGAffineTransform(rotationAngle: .pi/2 * 2)
	}

	func cornerHandleDidBecomeActive() {

		UIView.animate(withDuration: 0.15) {
			self.visualEffectView.alpha = 0.5
		}

	}

	func cornerHandleDidBecomeInactive(animated: Bool = true) {

		func setState() {
			self.visualEffectView.alpha = 1.0
		}

		if animated {
			UIView.animate(withDuration: 0.15) {
				setState()
			}
		} else {
			setState()
		}

	}

}

@IBDesignable
private class CornerHandleGlyphView: UIView {

	private let handleWidth: CGFloat = 6
	private let innerRadius: CGFloat = 24
	private let outerRadius: CGFloat = 28

	override func draw(_ rect: CGRect) {

		guard let context = UIGraphicsGetCurrentContext() else {
			return
		}

		self.tintColor.setFill()

        draw(in: context, rect: rect)

	}

    func draw(in context: CGContext, rect: CGRect) {

        context.saveGState()

        let outerRadii = CGSize(width: outerRadius, height: outerRadius)
        let innerRadii = CGSize(width: innerRadius, height: innerRadius)

        let outerRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width * 2, height: rect.height * 2)

        let outerRoundedRect = UIBezierPath(roundedRect: outerRect, byRoundingCorners: .topLeft, cornerRadii: outerRadii)

        let clipRect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.width - handleWidth/2, height: rect.height - handleWidth/2))

        clipRect.addClip()

        let innerRect = CGRect(x: rect.origin.x + handleWidth, y: rect.origin.y + handleWidth, width: rect.width*2, height: rect.height*2)

        let innerRoundedRect = UIBezierPath(roundedRect: innerRect, byRoundingCorners: .topLeft, cornerRadii: innerRadii)

        outerRoundedRect.append(innerRoundedRect)
        outerRoundedRect.usesEvenOddFillRule = true

        outerRoundedRect.addClip()

        context.fill(rect)

        context.restoreGState()

        context.fillEllipse(in: CGRect(x: 0, y: rect.height - handleWidth, width: handleWidth, height: handleWidth))

        context.fillEllipse(in: CGRect(x: rect.width - handleWidth, y: 0, width: handleWidth, height: handleWidth))

    }

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 38, height: 38)
	}

}
