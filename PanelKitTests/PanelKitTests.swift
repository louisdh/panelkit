//
//  PanelKitTests.swift
//  PanelKitTests
//
//  Created by Louis D'hauwe on 09/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import XCTest
@testable import PanelKit

class PanelKitTests: XCTestCase {
	
	var viewController: ViewController!
	var navigationController: UINavigationController!
	
    override func setUp() {
        super.setUp()
		
		viewController = ViewController()
		navigationController = UINavigationController(rootViewController: viewController)
		navigationController.view.frame = CGRect(origin: .zero, size: CGSize(width: 1024, height: 768))
		
		UIApplication.shared.keyWindow!.rootViewController!.present(navigationController, animated: false, completion: nil)
		
		XCTAssertNotNil(navigationController.view)
		XCTAssertNotNil(viewController.view)
		
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFloating() {
		
		let mapPanel = viewController.mapPanelVC!
		
		assert(!mapPanel.isFloating)
		assert(!mapPanel.isPinned)
		assert(!mapPanel.isPresentedModally)
		assert(!mapPanel.isPresentedAsPopover)

		let popoverExp = self.expectation(description: "popover")
		let popExp = self.expectation(description: "pop")

		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				assert(mapPanel.isFloating)
				popExp.fulfill()
				
			})
			
			popoverExp.fulfill()
			
		}
		
		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}

    }

}
