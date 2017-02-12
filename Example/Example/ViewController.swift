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
	
	// MARK: - Popover
	
	@IBAction func showMap(_ sender: UIBarButtonItem) {
	
		mapPanelVC.modalPresentationStyle = .popover
		
		mapPanelVC.popoverPresentationController?.barButtonItem = sender
		
		present(mapPanelVC, animated: true, completion: nil)
		
	}
	
	@IBAction func showTextViewPanel(_ sender: UIBarButtonItem) {
	
		textPanelVC.modalPresentationStyle = .popover
		
		textPanelVC.popoverPresentationController?.barButtonItem = sender
		
		present(textPanelVC, animated: true, completion: nil)
		
	}

	// MARK: - PanelManager
	
	var panelContentWrapperView: UIView {
		return contentWrapperView
	}
	
	var panelContentView: UIView {
		return contentView
	}
	
	var panelPinnedPreviewView: UIView?
	
	var panels: [PanelViewController?] {
		return [mapPanelVC, textPanelVC]
	}
	
	var allowFloatingPanels: Bool {
		return view.bounds.width > 800
	}
	
	var allowPanelPinning: Bool {
		return view.bounds.width > 800
	}
	
	func didUpdatePinnedPanels() {
		
		
	}
	
	func enablePanelShadow(for panel: PanelViewController) -> Bool {
		return true
	}
	
}
