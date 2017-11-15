//
//  PanelManager+Default.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 07/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit

public extension PanelManager {

	func didUpdatePinnedPanels() {

	}

	func enablePanelShadow(for panel: PanelViewController) -> Bool {
		return true
	}

	var allowFloatingPanels: Bool {
		return panelContentWrapperView.bounds.width > 800
	}

	var allowPanelPinning: Bool {
		return panelContentWrapperView.bounds.width > 800
	}

	func maximumNumberOfPanelsPinned(at side: PanelPinSide) -> Int {
		return 1
	}
	
	var panelManagerLogLevel: LogLevel {
		return .none
	}

	func dragInsets(for panel: PanelViewController) -> UIEdgeInsets {
		return .zero
	}

	func willEnterExpose() {

	}

	func willExitExpose() {

	}

	var exposeOverlayBlurEffect: UIBlurEffect {
		return UIBlurEffect(style: .light)
	}

}
