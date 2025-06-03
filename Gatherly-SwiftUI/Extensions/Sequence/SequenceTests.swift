//
//  SequenceTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/3/25.
//

import XCTest
@testable import Gatherly_SwiftUI

private struct DummyElement: Equatable {
    let id: Int?
    let value: String
}

final class SequenceTests: XCTestCase {
    
    func testKeyedBy_allElementsHaveIDs() {
        let elements: [DummyElement] = [
            DummyElement(id: 1, value: "One"),
            DummyElement(id: 2, value: "Two"),
            DummyElement(id: 3, value: "Three")
        ]
        
        let dict = elements.keyedBy(\.id)
        
        XCTAssertEqual(dict.count, 3)
        XCTAssertEqual(dict[1], DummyElement(id: 1, value: "One"))
        XCTAssertEqual(dict[2], DummyElement(id: 2, value: "Two"))
        XCTAssertEqual(dict[3], DummyElement(id: 3, value: "Three"))
    }
    
    func testKeyedBy_someElementsHaveNilIDs() {
        let elements: [DummyElement] = [
            DummyElement(id: 1, value: "One"),
            DummyElement(id: nil, value: "NilOne"),
            DummyElement(id: 2, value: "Two"),
            DummyElement(id: nil, value: "NilTwo")
        ]
        
        let dict = elements.keyedBy(\.id)
        
        // Only elements with non-nil IDs should appear
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict[1], DummyElement(id: 1, value: "One"))
        XCTAssertEqual(dict[2], DummyElement(id: 2, value: "Two"))
        XCTAssertNil(dict[3])
    }
    
    func testKeyedBy_emptySequence() {
        let elements: [DummyElement] = []
        let dict = elements.keyedBy(\.id)
        XCTAssertTrue(dict.isEmpty)
    }
    
    func testKeyedBy_duplicateIDs_lastOneWins() {
        // If two elements share the same non-nil ID, the latter should override
        let elements: [DummyElement] = [
            DummyElement(id: 1, value: "FirstOne"),
            DummyElement(id: 2, value: "FirstTwo"),
            DummyElement(id: 1, value: "SecondOne"),
            DummyElement(id: 2, value: "SecondTwo")
        ]
        
        let dict = elements.keyedBy(\.id)
        
        // The second occurrence with ID=1 should override the first
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict[1], DummyElement(id: 1, value: "SecondOne"))
        XCTAssertEqual(dict[2], DummyElement(id: 2, value: "SecondTwo"))
    }
}
