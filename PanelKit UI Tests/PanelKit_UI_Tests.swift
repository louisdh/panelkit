//
//  PanelKit_UI_Tests.swift
//  PanelKit UI Tests
//
//  Created by Louis D'hauwe on 01/03/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import XCTest
@testable import PanelKit

class PanelKit_UI_Tests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFloating() {

		XCUIDevice.shared.orientation = .landscapeLeft

		let app = XCUIApplication()
		let mapButton = app.navigationBars["PanelKit Example"].buttons["Map"]
		let mapNavigationBar = app.navigationBars["Map"]

		mapButton.tap()

		mapNavigationBar.buttons["⬇︎"].tap()

//		let mapStaticText = mapNavigationBar.staticTexts["Map"]
//		mapStaticText.tap()

		mapNavigationBar.buttons["Close"].tap()

    }

}
