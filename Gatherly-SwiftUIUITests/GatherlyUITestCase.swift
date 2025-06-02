//
//  GatherlyUITestCase.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

class GatherlyUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchEnvironment["UITESTING"] = "1"
        app.launch()
        
        let calendarTab = app.tabBars.buttons["Calendar"]
        XCTAssertTrue(calendarTab.waitForExistence(timeout: 7), "Calendar tab failed to appear")
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
}
