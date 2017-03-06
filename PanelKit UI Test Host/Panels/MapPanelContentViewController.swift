//
//  MapPanelContentViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 01/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import PanelKit
import MapKit

class MapPanelContentViewController: PanelContentViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Map"

	}

	override var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}

}
