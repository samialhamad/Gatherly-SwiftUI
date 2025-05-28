//
//  GetGroupsTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GetGroupsTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testGetGroupsReturnsStoredGroups() {
        let expectation = XCTestExpectation(description: "Groups are loaded from UserDefaults")
        
        let group = UserGroup(
            bannerImageName: "banner_img.png",
            id: 123,
            imageName: "group_img.png",
            leaderID: 1,
            memberIDs: [2, 3],
            messages: [],
            name: "Test Group"
        )
        
        UserDefaultsManager.saveGroups([group])
        
        GatherlyAPI.getGroups()
            .sink { groups in
                XCTAssertEqual(groups.count, 1)
                XCTAssertEqual(groups.first?.id, 123)
                XCTAssertEqual(groups.first?.name, "Test Group")
                XCTAssertEqual(groups.first?.leaderID, 1)
                XCTAssertEqual(groups.first?.memberIDs, [2, 3])
                XCTAssertEqual(groups.first?.imageName, "group_img.png")
                XCTAssertEqual(groups.first?.bannerImageName, "banner_img.png")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
