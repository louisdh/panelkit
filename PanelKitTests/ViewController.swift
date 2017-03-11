//
//  ViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit
import PanelKit

class ViewController: UIViewController, PanelManager {

	var mapPanelContentVC: MapPanelContentViewController!
	var mapPanelVC: PanelViewController!

	var textPanelContentVC: TextPanelContentViewController!
	var textPanelVC: PanelViewController!

	var contentWrapperView: UIView!
	var contentView: UIView!

	var mapPanelBarBtn: UIBarButtonItem!
	var textPanelBarBtn: UIBarButtonItem!

	override func viewDidLoad() {
		super.viewDidLoad()

		contentWrapperView = UIView(frame: view.bounds)
		view.addSubview(contentWrapperView)

		contentView = UIView(frame: contentWrapperView.bounds)
		contentWrapperView.addSubview(contentView)

		mapPanelContentVC = MapPanelContentViewController()

		mapPanelVC = PanelViewController(with: mapPanelContentVC, contentDelegate: mapPanelContentVC, in: self)

		textPanelContentVC = TextPanelContentViewController()

		textPanelVC = PanelViewController(with: textPanelContentVC, contentDelegate: textPanelContentVC, in: self)

		enableTripleTapExposeActivation()

		mapPanelBarBtn = UIBarButtonItem(title: "Map", style: .done, target: self, action: nil)
		textPanelBarBtn = UIBarButtonItem(title: "Text", style: .done, target: self, action: nil)

		self.navigationItem.title = "Test"
		self.navigationItem.rightBarButtonItems = [mapPanelBarBtn, textPanelBarBtn]

	}

	// MARK: - Popover

	func showMapPanelFromBarButton(completion: @escaping (() -> Void)) {
		showPopover(mapPanelVC, from: mapPanelBarBtn, completion: completion)
	}

	func showTextPanelFromBarButton(completion: @escaping (() -> Void)) {
		showPopover(textPanelVC, from: textPanelBarBtn, completion: completion)
	}

	func showPopover(_ vc: UIViewController, from barButtonItem: UIBarButtonItem, completion: (() -> Void)? = nil) {

		vc.modalPresentationStyle = .popover
		vc.popoverPresentationController?.barButtonItem = barButtonItem

		present(vc, animated: false, completion: completion)

	}

	// MARK: - PanelManager

	let panelManagerLogLevel: LogLevel = .full

	var panelContentWrapperView: UIView {
		return contentWrapperView
	}

	var panelContentView: UIView {
		return contentView
	}

	var panels: [PanelViewController] {
		return [mapPanelVC, textPanelVC]
	}

}
