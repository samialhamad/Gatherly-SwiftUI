//
//  UserDefaultsTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/17/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserDefaultsTests: XCTestCase {
    
    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    let testKey = "testModelKey"

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: testKey)
    }

    func testSetAndGetCodable_Succeeds() {
        let model = TestModel(id: 1, name: "Test User")
        UserDefaults.standard.setCodable(model, forKey: testKey)
        
        let retrieved: TestModel? = UserDefaults.standard.getCodable(forKey: testKey, type: TestModel.self)
        
        XCTAssertEqual(retrieved, model)
    }
    
    func testGetCodable_ReturnsNilIfNotSet() {
        let missing: TestModel? = UserDefaults.standard.getCodable(forKey: "nonexistentKey", type: TestModel.self)
        XCTAssertNil(missing)
    }
}
