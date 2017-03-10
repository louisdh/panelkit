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
	
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	
		XCTAssertNotNil(navigationController.view)
		XCTAssertNotNil(viewController.view)

    }

    override func tearDown() {
        super.tearDown()
		// Put teardown code here. This method is called after the invocation of each test method in the class.
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
	
	func testExpose() {
		
		let mapPanel = viewController.mapPanelVC!
		let textPanel = viewController.textPanelVC!
		
		let exp = self.expectation(description: "expose")
		
		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				self.viewController.showTextPanelFromBarButton {

					self.viewController.toggleFloatStatus(for: textPanel, completion: {

						assert(mapPanel.isFloating)
						assert(textPanel.isFloating)
						
						self.viewController.enterExpose()
						
						assert(mapPanel.isInExpose)
						assert(textPanel.isInExpose)
						
						self.viewController.exitExpose()
						
						assert(!mapPanel.isInExpose)
						assert(!textPanel.isInExpose)
						
						exp.fulfill()
						
					})
					
				}
				
			})
			
		}
		
		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
		
	}
	
	func testPinned() {

		let mapPanel = viewController.mapPanelVC!
		
		let popoverExp = self.expectation(description: "popover")
		let popExp = self.expectation(description: "pop")
		
		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				self.viewController.didEndDrag(mapPanel, toEdgeOf: .right)

				assert(mapPanel.isPinned)
				assert(self.viewController.panelPinnedRight == mapPanel)
				
				
				self.viewController.didDragFree(mapPanel)
				assert(!mapPanel.isPinned)
				assert(self.viewController.panelPinnedRight == nil)

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
	
	func testKeyboard() {

		let textPanel = viewController.textPanelVC!
		
		let popoverExp = self.expectation(description: "popover")
		let popExp = self.expectation(description: "pop")
		
		viewController.showTextPanelFromBarButton {
			
			assert(textPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: textPanel, completion: {
				
				let textView = self.viewController.textPanelContentVC.textView
				
				textView!.becomeFirstResponder()
				
				assert(textView!.isFirstResponder)
				
				textView!.resignFirstResponder()

				assert(!textView!.isFirstResponder)

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

	func testOffOnScreen() {
		
		let mapPanel = viewController.mapPanelVC!
		
		let popoverExp = self.expectation(description: "popover")
		let popExp = self.expectation(description: "pop")
		
		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				// Move off screen
				
				self.viewController.panelsPrepareMoveOffScreen()
				self.viewController.panelsMovePanelOffScreen()
				
				self.viewController.view.layoutIfNeeded()
				self.viewController.panelsCompleteMoveOffScreen()
				
				let vcFrame = self.viewController.view.bounds
				let mapPanelFrame = mapPanel.view.frame
				
				assert(!vcFrame.intersects(mapPanelFrame))
				
				
				// Move on screen
				
				self.viewController.panelsPrepareMoveOnScreen()
				self.viewController.panelsMovePanelOnScreen()
				
				self.viewController.view.layoutIfNeeded()
				self.viewController.panelsCompleteMoveOnScreen()

				let mapPanelFrameOn = mapPanel.view.frame
				assert(vcFrame.intersects(mapPanelFrameOn))

				
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
	
	func testClosing() {
		
		let mapPanel = viewController.mapPanelVC!
		
		let popoverExp = self.expectation(description: "popover")
		let popExp = self.expectation(description: "pop")
		
		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				assert(mapPanel.isFloating)

				self.viewController.close(mapPanel)
				
				assert(!mapPanel.isFloating)
				
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
	
	func testDragToPin() {
		
		let mapPanel = viewController.mapPanelVC!
		
		let exp = self.expectation(description: "dragToPin")
		
		viewController.showMapPanelFromBarButton {
			
			assert(mapPanel.isPresentedAsPopover)
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				let from = mapPanel.view.center
				let toX = self.viewController.view.bounds.width - mapPanel.contentViewController!.view.bounds.width/2
				let to = CGPoint(x: toX, y: mapPanel.view.center.y)
				mapPanel.panelNavigationController.moveWithTouch(from: from, to: to)
				self.viewController.view.layoutIfNeeded()
				
				mapPanel.panelNavigationController.moveWithTouch(from: to, to: to)

				mapPanel.didEndDrag()
				
				assert(mapPanel.isPinned)
				assert(self.viewController.panelPinnedRight == mapPanel)
				
				
				mapPanel.panelNavigationController.moveWithTouch(from: to, to: from)
				self.viewController.view.layoutIfNeeded()
				mapPanel.didEndDrag()

				assert(!mapPanel.isPinned)
				assert(self.viewController.panelPinnedRight == nil)
				
				
				exp.fulfill()

			})
			
		}
		
		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
		
	}
	
}
