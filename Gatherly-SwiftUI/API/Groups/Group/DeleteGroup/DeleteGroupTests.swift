//
//  DeleteGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class DeleteGroupTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testDeleteGroup() {
        let expectation = XCTestExpectation(description: "Group is deleted from UserDefaults")
        
        var groupToDelete = UserGroup(
            id: 101,
            leaderID: 1,
            memberIDs: [],
            name: "Delete Me"
        )
        
        let groupToKeep = UserGroup(
            id: 102,
            leaderID: 2,
            memberIDs: [],
            name: "Keep Me"
        )
        
        UserDefaultsManager.saveGroups([
            groupToDelete.id!: groupToDelete,
            groupToKeep.id!: groupToKeep
        ])
        
        GatherlyAPI.deleteGroup(id: groupToDelete.id!)
            .sink { success in
                XCTAssertTrue(success, "Expected deleteGroup to return true")
                
                let storedDict = UserDefaultsManager.loadGroups()
                
                XCTAssertEqual(storedDict.count, 1)
                XCTAssertFalse(storedDict.keys.contains(groupToDelete.id!))
                XCTAssertTrue(storedDict.keys.contains(groupToKeep.id!))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteGroupFailsForNonexistentGroup() {
        let expectation = XCTestExpectation(description: "Deletion should fail if group doesn't exist")
        
        let fakeGroup = UserGroup(
            id: 999,
            leaderID: 1,
            memberIDs: [],
            name: "Ghost Group"
        )
        
        UserDefaultsManager.saveGroups([:])
        
        GatherlyAPI.deleteGroup(id: fakeGroup.id!)
            .sink { success in
                XCTAssertFalse(success)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
