//
//  PanelNavigationController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 10/09/16.
//  Copyright © 2016-2017 Silver Fox. All rights reserved.
//

import UIKit

@objc public class PanelNavigationController: UINavigationController {

	public weak var panelViewController: PanelViewController?

    override public func viewDidLoad() {
        super.viewDidLoad()

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBar(_ :)))
		tapGestureRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapGestureRecognizer)

    }

	deinit {
		if panelViewController?.logLevel == .full {
			print("deinit \(self)")
		}
	}

	@objc private func didTapBar(_ gestureRecognizer: UITapGestureRecognizer) {

		if self.panelViewController?.isPinned != true {
			self.panelViewController?.bringToFront()
		}

	}

}
