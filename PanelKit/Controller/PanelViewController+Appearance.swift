//
//  PanelViewController+Appearance.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

extension PanelViewController {

	var tintColor: UIColor {
		return panelNavigationController.navigationBar.tintColor
	}

	var shadowLayer: CALayer {
		return shadowView.layer
	}

	func disableShadow(animated: Bool = false, duration: Double = 0.3) {

		if animated {

			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = shadowLayer.shadowOpacity
			anim.toValue = 0.0
			anim.duration = duration
			shadowLayer.add(anim, forKey: #keyPath(CALayer.shadowOpacity))

		}

		shadowLayer.shadowOpacity = 0.0

		isShadowForceDisabled = true
	}

	func enableShadow(animated: Bool = false, duration: Double = 0.3) {

		if animated {

			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = shadowLayer.shadowOpacity
			anim.toValue = shadowOpacity
			anim.duration = duration
			shadowLayer.add(anim, forKey: #keyPath(CALayer.shadowOpacity))

		}

		shadowLayer.shadowOpacity = shadowOpacity

		isShadowForceDisabled = false

	}

	func disableCornerRadius(animated: Bool = false, duration: Double = 0.3) {

		if animated {

			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = panelNavigationController.view.layer.cornerRadius
			anim.toValue = 0.0
			anim.duration = duration
			panelNavigationController.view.layer.add(anim, forKey: #keyPath(CALayer.cornerRadius))

		}

		panelNavigationController.view.layer.cornerRadius = 0.0

		panelNavigationController.view.clipsToBounds = true

	}

	func enableCornerRadius(animated: Bool = false, duration: Double = 0.3) {

		if animated {

			let anim = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
			anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			anim.fromValue = panelNavigationController.view.layer.cornerRadius
			anim.toValue = cornerRadius
			anim.duration = duration
			panelNavigationController.view.layer.add(anim, forKey: #keyPath(CALayer.cornerRadius))

		}

		panelNavigationController.view.layer.cornerRadius = cornerRadius

		panelNavigationController.view.clipsToBounds = true

	}

	var shadowEnabled: Bool {
		return manager?.enablePanelShadow(for: self) == true
	}

	func updateShadow() {

		if isShadowForceDisabled {
			return
		}

		if shadowEnabled {

			shadowLayer.shadowRadius = shadowRadius
			shadowLayer.shadowOpacity = shadowOpacity
			shadowLayer.shadowOffset = shadowOffset
			shadowLayer.shadowColor = shadowColor

		} else {

			shadowLayer.shadowRadius = 0.0
			shadowLayer.shadowOpacity = 0.0

		}

	}

}
