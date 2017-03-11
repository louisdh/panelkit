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

class MapPanelContentViewController: UIViewController, PanelContentDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Map"

    }

	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}

}
