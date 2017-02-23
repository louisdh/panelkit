//
//  ViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

class ViewController: UIViewController, PanelManager {

	var mapPanelContentVC: MapPanelContentViewController!
	var mapPanelVC: PanelViewController!
	
	var textPanelContentVC: TextPanelContentViewController!
	var textPanelVC: PanelViewController!
	

	@IBOutlet weak var contentWrapperView: UIView!
	@IBOutlet weak var contentView: UIView!
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapPanelContentVC = storyboard?.instantiateViewController(withIdentifier: "MapPanelContentViewController") as! MapPanelContentViewController
		
		mapPanelVC = PanelViewController(with: mapPanelContentVC, in: self)
		
		
		textPanelContentVC = storyboard?.instantiateViewController(withIdentifier: "TextPanelContentViewController") as! TextPanelContentViewController
		
		textPanelVC = PanelViewController(with: textPanelContentVC, in: self)
		
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		coordinator.animate(alongsideTransition: { (context) in
			
		}) { (context) in
			
			if !self.allowFloatingPanels {
				self.closeAllFloatingPanels()
			}
			
			if !self.allowPanelPinning {
				self.closeAllPinnedPanels()
			}
			
		}
		
	}
	
	// MARK: - Exposé
	
	@IBAction func toggleExpose(_ sender: UIBarButtonItem) {
	
		self.enterExpose()
		
	}
	
	// MARK: - Popover
	
	@IBAction func showMap(_ sender: UIBarButtonItem) {

		showPopover(mapPanelVC, from: sender)

	}
	
	@IBAction func showTextViewPanel(_ sender: UIBarButtonItem) {
		
		showPopover(textPanelVC, from: sender)
		
	}
	
	func showPopover(_ vc: UIViewController, from barButtonItem: UIBarButtonItem) {
		
		vc.modalPresentationStyle = .popover
		vc.popoverPresentationController?.barButtonItem = barButtonItem
		
		present(vc, animated: true, completion: nil)
		
	}

	// MARK: - PanelManager
	
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
