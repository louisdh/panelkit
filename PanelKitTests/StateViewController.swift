//
//  StateViewController.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 16/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import UIKit
import PanelKit

class StateViewController: UIViewController {
	
	var panel1ContentVC: TestPanel1!
	var panel1VC: PanelViewController!
	
	var panel2ContentVC: TestPanel2!
	var panel2VC: PanelViewController!
	
	var contentWrapperView: UIView!
	var contentView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		contentWrapperView = UIView(frame: view.bounds)
		view.addSubview(contentWrapperView)
		
		contentView = UIView(frame: contentWrapperView.bounds)
		contentWrapperView.addSubview(contentView)
		
		panel1ContentVC = TestPanel1()
		panel1VC = PanelViewController(with: panel1ContentVC, in: self)
		
		panel2ContentVC = TestPanel2()
		panel2VC = PanelViewController(with: panel2ContentVC, in: self)
		
		self.navigationItem.title = "Test"
		
	}
	
}

extension StateViewController: PanelManager {
	
	var panelManagerLogLevel: LogLevel {
		return .full
	}
	
	var panelContentWrapperView: UIView {
		return contentWrapperView
	}
	
	var panelContentView: UIView {
		return contentView
	}
	
	var panels: [PanelViewController] {
		return [panel1VC, panel2VC]
	}
	
	func maximumNumberOfPanelsPinned(at side: PanelPinSide) -> Int {
		return 2
	}
	
}

class TestPanel1: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .red
		
		self.title = "Test Panel 1"
		
	}
	
}

extension TestPanel1: PanelContentDelegate {
	
	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}
	
	var minimumPanelContentSize: CGSize {
		return CGSize(width: 300, height: 400)
	}
	
	var maximumPanelContentSize: CGSize {
		return CGSize(width: 600, height: 600)
	}
	
}

extension TestPanel1: PanelStateCoder {

	var panelId: Int {
		return 1
	}

}

class TestPanel2: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .green
		
		self.title = "Test Panel 2"
		
	}
	
}

extension TestPanel2: PanelContentDelegate {
	
	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 500)
	}

}

extension TestPanel2: PanelStateCoder {
	
	var panelId: Int {
		return 2
	}
	
}
