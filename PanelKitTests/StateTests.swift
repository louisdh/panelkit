//
//  StateTests.swift
//  PanelKitTests
//
//  Created by Louis D'hauwe on 16/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import XCTest
import UIKit
@testable import PanelKit

class StateTests: XCTestCase {
	
	var viewController: StateViewController!
	var navigationController: UINavigationController!
	
	override func setUp() {
		super.setUp()
		
		viewController = StateViewController()
		
		navigationController = UINavigationController(rootViewController: viewController)
		navigationController.view.frame = CGRect(origin: .zero, size: CGSize(width: 1024, height: 768))
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		
		XCTAssertNotNil(navigationController.view)
		XCTAssertNotNil(viewController.view)
		
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCTFail("Test does not work on an iPhone")
        }
	}
	
	override func tearDown() {
		super.tearDown()
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testFloatPanel() {
		
		viewController.float(viewController.panel1VC, at: CGRect(x: 200, y: 200, width: 300, height: 300))
		
		XCTAssert(viewController.panel1VC.isFloating)
		
	}
	
	func testPinMultiplePanelsRight() {
		
		viewController.pin(viewController.panel1VC, to: .right, atIndex: 0)
		viewController.pin(viewController.panel2VC, to: .right, atIndex: 0)

		XCTAssert(viewController.numberOfPanelsPinned(at: .right) == 2)
		XCTAssert(viewController.panel1VC.isPinned)
		XCTAssert(viewController.panel2VC.isPinned)

	}
	
	func testPinMultiplePanelsLeft() {
		
		viewController.pin(viewController.panel1VC, to: .left, atIndex: 0)
		viewController.pin(viewController.panel2VC, to: .left, atIndex: 0)
		
		XCTAssert(viewController.numberOfPanelsPinned(at: .left) == 2)
		XCTAssert(viewController.panel1VC.isPinned)
		XCTAssert(viewController.panel2VC.isPinned)
		
	}
	
	func testEncodeStates() {
		
		viewController.pin(viewController.panel1VC, to: .left, atIndex: 0)
		viewController.pin(viewController.panel2VC, to: .right, atIndex: 0)
		
		let states = viewController.panelStates
		
		guard let state1 = states[1] else {
			XCTFail("Expected state 1")
			return
		}
		
		guard let state2 = states[2] else {
			XCTFail("Expected state 2")
			return
		}

		XCTAssert(state1.pinnedMetadata?.side == .left)
		XCTAssert(state2.pinnedMetadata?.side == .right)
		
	}
	
	func testDecodeStates() {
		
		let json = """
					{
					   "2": {
						  "floatingState": {
							"relativePosition": [0.4, 0.4],
							"zIndex": 0
						  }
					   },
					   "1": {
						  "pinnedMetadata": {
							 "side": 0,
							 "index": 0,
							 "date": 532555376.97106999
						  }
					   }
					}
				"""
		
		let decoder = JSONDecoder()
		let states = try! decoder.decode([Int: PanelState].self, from: json.data(using: .utf8)!)
		
		guard let state1 = states[1] else {
			XCTFail("Expected state 1")
			return
		}
		
		guard let state2 = states[2] else {
			XCTFail("Expected state 2")
			return
		}
		
		XCTAssert(state1.pinnedMetadata?.side == .left)
		XCTAssert(state2.floatingState?.zIndex == 0)
		
		viewController.restorePanelStates(states)

		XCTAssert(viewController.numberOfPanelsPinned(at: .left) == 1)
		XCTAssert(viewController.numberOfPanelsPinned(at: .right) == 0)
		XCTAssert(viewController.panel1VC.isPinned)
		XCTAssert(viewController.panel2VC.isFloating)
	}
	
}
