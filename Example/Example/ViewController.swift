//
//  ViewController.swift
//  Example
//
//  Created by Louis D'hauwe on 12/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

extension UIViewController {
	
	public var isPresentedAsPopover: Bool {
		get {
			
			if let p = self.popoverPresentationController {
				
				// FIXME: presentedViewController can never be nil?
				let c = p.presentedViewController as UIViewController?
				
				return c != nil && p.arrowDirection != .unknown
				
			} else {
				
				return false
				
			}
			
		}
	}
	
}

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
	
	// MARK: - 
	
	func didToggle(_ panel: PanelViewController) {
		
		let panelNavCon = panel.panelNavigationController
		
		if panel.contentViewController!.isShownAsPanel && !panelNavCon.isPresentedAsPopover {
			
			panel.view.removeFromSuperview()

			panel.contentViewController?.setAsPanel(false)
			
		} else {
			
			let rect = panel.view.convert(panel.view.frame, to: self.contentWrapperView)
			
			panel.dismiss(animated: false, completion: {
				
				self.contentWrapperView.addSubview(panel.view)
				
				panel.view.frame = rect
				
				UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: { 
					
					let x = rect.origin.x
					
					let y: CGFloat = 12.0
					
					let width = panel.view.frame.size.width
					
					let height = max(panel.view.frame.size.height, 44*5)
					
					panel.view.frame = CGRect(x: x, y: y, width: width, height: height)
					panel.view.center = panel.allowedCenter(for: panel.view.center)
					
				}, completion: nil)
		
				
				panel.contentViewController?.setAutoResizingMask()
				
				if panel.view.superview == self.contentWrapperView {
					panel.contentViewController?.setAsPanel(true)
					panelNavCon.setAsPanel(true)
				}
			
				
			})
		
		}
	
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

