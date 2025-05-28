//
//  MessageTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class MessageTests: XCTestCase {

    // MARK: - Equatable
    
    func testEqualTrue() {
        let message0 = Message(id: 0, userID: 0, message: "", read: true)
        let message1 = Message(id: 0, userID: 0, message: "", read: true)
        XCTAssertEqual(message0, message1)
    }
    
    func testEqualFalse() {
        let message0 = Message(id: 0, userID: 0, message: "", read: true)
        let message1 = Message(id: 0, userID: 0, message: "", read: false)
        XCTAssertNotEqual(message0, message1)
    }
}
