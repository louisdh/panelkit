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

	var mapPanelContentViewController: MapPanelContentViewController!
	var mapPanelViewController: PanelViewController!
	
	var textPanelContentViewController: TextPanelContentViewController!
	var textPanelViewController: PanelViewController!
	

	@IBOutlet weak var contentWrapperView: UIView!
	@IBOutlet weak var contentView: UIView!
	
	var privatePanelPinnedPreviewView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapPanelContentViewController = storyboard?.instantiateViewController(withIdentifier: "MapPanelContentViewController") as! MapPanelContentViewController
		
		mapPanelContentViewController.panelDelegate = self

		mapPanelViewController = PanelViewController(with: mapPanelContentViewController)
		mapPanelViewController.preferredContentSize = mapPanelContentViewController.contentSize()
		mapPanelViewController.delegate = self
		
		
		textPanelContentViewController = storyboard?.instantiateViewController(withIdentifier: "TextPanelContentViewController") as! TextPanelContentViewController
		
		textPanelContentViewController.panelDelegate = self
		
		textPanelViewController = PanelViewController(with: textPanelContentViewController)
		textPanelViewController.preferredContentSize = textPanelContentViewController.contentSize()
		textPanelViewController.delegate = self
		
		
	}
	
	// MARK: -
	
	@IBAction func showMap(_ sender: UIBarButtonItem) {
	
		mapPanelViewController.modalPresentationStyle = .popover
		
		mapPanelViewController.popoverPresentationController?.barButtonItem = sender
		
		present(mapPanelViewController, animated: true, completion: nil)
		
	}
	
	@IBAction func showTextViewPanel(_ sender: UIBarButtonItem) {
	
		textPanelViewController.modalPresentationStyle = .popover
		
		textPanelViewController.popoverPresentationController?.barButtonItem = sender
		
		present(textPanelViewController, animated: true, completion: nil)
		
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
		return [mapPanelViewController, textPanelViewController]
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

