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
    
    private func makeGroup(id: Int, name: String) -> UserGroup {
        UserGroup(
            bannerImageName: "banner_img.png",
            id: id,
            imageName: "group_img.png",
            leaderID: 1,
            memberIDs: [2, 3],
            messages: [],
            name: name
        )
    }
    
    func testGetGroupsReturnsNoGroups() {
        let expectation = XCTestExpectation(description: "No groups are loaded from UserDefaults")
        
        GatherlyAPI.getGroups()
            .sink { groups in
                XCTAssertEqual(groups.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetGroupsReturnsStoredGroup() {
        let expectation = XCTestExpectation(description: "One group is loaded from UserDefaults")
        
        let group = makeGroup(id: 123, name: "Test Group")
        
        UserDefaultsManager.saveGroups([group.id!: group])
        
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
    
    func testGetGroupsReturnsStoredGroups() {
        let expectation = XCTestExpectation(description: "Two groups are loaded from UserDefaults")
        
        let group1 = makeGroup(id: 123, name: "Group 1")
        let group2 = makeGroup(id: 456, name: "Group 2")
        
        UserDefaultsManager.saveGroups([
            group1.id!: group1,
            group2.id!: group2
        ])
        
        GatherlyAPI.getGroups()
            .sink { groups in
                let sortedGroups = groups.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
                
                XCTAssertEqual(sortedGroups.count, 2)
                
                let first = sortedGroups[0]
                XCTAssertEqual(first.id, 123)
                XCTAssertEqual(first.name, "Group 1")
                XCTAssertEqual(first.leaderID, 1)
                XCTAssertEqual(first.memberIDs, [2, 3])
                XCTAssertEqual(first.imageName, "group_img.png")
                XCTAssertEqual(first.bannerImageName, "banner_img.png")
                
                let second = sortedGroups[1]
                XCTAssertEqual(second.id, 456)
                XCTAssertEqual(second.name, "Group 2")
                XCTAssertEqual(second.leaderID, 1)
                XCTAssertEqual(second.memberIDs, [2, 3])
                XCTAssertEqual(second.imageName, "group_img.png")
                XCTAssertEqual(second.bannerImageName, "banner_img.png")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
