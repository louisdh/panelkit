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
import UIKit

class MapPanelContentViewController: UIViewController, PanelContentDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Map"

	}

	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}

}
