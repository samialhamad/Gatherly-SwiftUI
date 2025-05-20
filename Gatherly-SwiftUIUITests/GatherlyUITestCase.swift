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
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
}
