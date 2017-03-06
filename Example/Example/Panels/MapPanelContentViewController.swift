//
//  MapPanelContentViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
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
