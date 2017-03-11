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

		XCTAssert(!mapPanel.isFloating)
		XCTAssert(!mapPanel.isPinned)
		XCTAssert(!mapPanel.isPresentedModally)
		XCTAssert(!mapPanel.isPresentedAsPopover)

		let exp = self.expectation(description: "floating")

		viewController.showMapPanelFromBarButton {

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				XCTAssert(mapPanel.isFloating)
				
				self.viewController.toggleFloatStatus(for: mapPanel, completion: {
					
					XCTAssert(!mapPanel.isFloating)
					exp.fulfill()
					
				})
				
			})

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

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				self.viewController.showTextPanelFromBarButton {

					self.viewController.toggleFloatStatus(for: textPanel, completion: {

						XCTAssert(mapPanel.isFloating)
						XCTAssert(textPanel.isFloating)

						self.viewController.enterExpose()

						XCTAssert(mapPanel.isInExpose)
						XCTAssert(textPanel.isInExpose)

						self.viewController.exitExpose()

						XCTAssert(!mapPanel.isInExpose)
						XCTAssert(!textPanel.isInExpose)

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

	func testPinnedFloating() {

		let mapPanel = viewController.mapPanelVC!
		let textPanel = viewController.textPanelVC!

		let exp = self.expectation(description: "pinnedFloating")
		
		viewController.showMapPanelFromBarButton {
			
			self.viewController.toggleFloatStatus(for: mapPanel, completion: {
				
				self.viewController.showTextPanelFromBarButton {

					self.viewController.toggleFloatStatus(for: textPanel, completion: {

						self.viewController.didEndDrag(mapPanel, toEdgeOf: .right)
						
						XCTAssert(mapPanel.isPinned)
						XCTAssert(self.viewController.panelPinnedRight == mapPanel)
						
						self.viewController.didDragFree(mapPanel)
						XCTAssert(!mapPanel.isPinned)
						XCTAssert(self.viewController.panelPinnedRight == nil)
						
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

		let exp = self.expectation(description: "pinned")

		viewController.showMapPanelFromBarButton {

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				self.viewController.didEndDrag(mapPanel, toEdgeOf: .right)

				XCTAssert(mapPanel.isPinned)
				XCTAssert(self.viewController.panelPinnedRight == mapPanel)

				self.viewController.didDragFree(mapPanel)
				XCTAssert(!mapPanel.isPinned)
				XCTAssert(self.viewController.panelPinnedRight == nil)

				exp.fulfill()

			})

		}

		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}

	}

	func testKeyboard() {

		let textPanel = viewController.textPanelVC!

		let exp = self.expectation(description: "keyboard")

		viewController.showTextPanelFromBarButton {

			XCTAssert(textPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: textPanel, completion: {

				let textView = self.viewController.textPanelContentVC.textView

				textView!.becomeFirstResponder()

				XCTAssert(textView!.isFirstResponder)

				textView!.resignFirstResponder()

				XCTAssert(!textView!.isFirstResponder)

				exp.fulfill()

			})

		}

		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testOffOnScreen() {

		let mapPanel = viewController.mapPanelVC!

		let exp = self.expectation(description: "offOnScreen")

		viewController.showMapPanelFromBarButton {

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				// Move off screen

				self.viewController.panelsPrepareMoveOffScreen()
				self.viewController.panelsMovePanelOffScreen()

				self.viewController.view.layoutIfNeeded()
				self.viewController.panelsCompleteMoveOffScreen()

				let vcFrame = self.viewController.view.bounds
				let mapPanelFrame = mapPanel.view.frame

				XCTAssert(!vcFrame.intersects(mapPanelFrame))

				// Move on screen

				self.viewController.panelsPrepareMoveOnScreen()
				self.viewController.panelsMovePanelOnScreen()

				self.viewController.view.layoutIfNeeded()
				self.viewController.panelsCompleteMoveOnScreen()

				let mapPanelFrameOn = mapPanel.view.frame
				XCTAssert(vcFrame.intersects(mapPanelFrameOn))

				exp.fulfill()

			})

		}

		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}

	}

	func testClosing() {

		let mapPanel = viewController.mapPanelVC!

		let exp = self.expectation(description: "closing")

		viewController.showMapPanelFromBarButton {

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				XCTAssert(mapPanel.isFloating)

				self.viewController.close(mapPanel)

				XCTAssert(!mapPanel.isFloating)

				exp.fulfill()

			})

		}

		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}

	}

	func testClosingAllFloating() {

		let mapPanel = viewController.mapPanelVC!

		let exp = self.expectation(description: "closing")

		viewController.showMapPanelFromBarButton {

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				XCTAssert(mapPanel.isFloating)

				self.viewController.closeAllFloatingPanels()

				XCTAssert(!mapPanel.isFloating)

				exp.fulfill()

			})

		}

		waitForExpectations(timeout: 10.0) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}

	}

	func testClosingAllPinned() {

		let mapPanel = viewController.mapPanelVC!
		let textPanel = viewController.textPanelVC!

		let exp = self.expectation(description: "closing")

		viewController.showMapPanelFromBarButton {

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				self.viewController.didEndDrag(mapPanel, toEdgeOf: .right)

				XCTAssert(mapPanel.isPinned)
				XCTAssert(self.viewController.panelPinnedRight == mapPanel)

				
				self.viewController.showTextPanelFromBarButton {

					self.viewController.toggleFloatStatus(for: textPanel, completion: {
						
						self.viewController.didEndDrag(textPanel, toEdgeOf: .left)

						XCTAssert(textPanel.isPinned)
						XCTAssert(self.viewController.panelPinnedLeft == textPanel)

						self.viewController.closeAllPinnedPanels()
						
						XCTAssert(!mapPanel.isPinned)
						XCTAssert(self.viewController.panelPinnedRight == nil)
						
						XCTAssert(!textPanel.isPinned)
						XCTAssert(self.viewController.panelPinnedLeft == nil)
						
						
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

	func testDragToPin() {

		let mapPanel = viewController.mapPanelVC!

		let exp = self.expectation(description: "dragToPin")

		viewController.showMapPanelFromBarButton {

			XCTAssert(mapPanel.isPresentedAsPopover)

			self.viewController.toggleFloatStatus(for: mapPanel, completion: {

				let from = mapPanel.view.center
				let toX = self.viewController.view.bounds.width - mapPanel.contentViewController!.view.bounds.width/2
				let to = CGPoint(x: toX, y: mapPanel.view.center.y)
				mapPanel.panelNavigationController.moveWithTouch(from: from, to: to)
				self.viewController.view.layoutIfNeeded()

				mapPanel.panelNavigationController.moveWithTouch(from: to, to: to)

				mapPanel.didEndDrag()

				XCTAssert(mapPanel.isPinned)
				XCTAssert(self.viewController.panelPinnedRight == mapPanel)

				mapPanel.panelNavigationController.moveWithTouch(from: to, to: from)
				self.viewController.view.layoutIfNeeded()
				mapPanel.didEndDrag()

				XCTAssert(!mapPanel.isPinned)
				XCTAssert(self.viewController.panelPinnedRight == nil)

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
