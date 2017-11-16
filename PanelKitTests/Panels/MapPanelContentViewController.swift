//
//  MapPanelContentViewController.swift
//  PanelKitTests
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import PanelKit
import MapKit
import UIKit

class MapPanelContentViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let mapView = MKMapView(frame: view.bounds)
		self.view.addSubview(mapView)

		self.title = "Map"

	}

}

extension MapPanelContentViewController: PanelContentDelegate {

	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}

}
