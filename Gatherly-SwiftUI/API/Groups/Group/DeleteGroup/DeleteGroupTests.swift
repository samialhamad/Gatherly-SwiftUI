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
            messages: [],
            name: "Delete Me"
        )
        
        let groupToKeep = UserGroup(
            id: 102,
            leaderID: 2,
            memberIDs: [],
            messages: [],
            name: "Keep Me"
        )
        
        UserDefaultsManager.saveGroups([groupToDelete, groupToKeep])
        
        GatherlyAPI.deleteGroup(groupToDelete)
            .sink { _ in 
                   let storedGroups = UserDefaultsManager.loadGroups()
                   XCTAssertEqual(storedGroups.count, 1)
                   XCTAssertFalse(storedGroups.contains { $0.id == groupToDelete.id })
                   XCTAssertTrue(storedGroups.contains { $0.id == groupToKeep.id })
                   expectation.fulfill()
               }
               .store(in: &cancellables)

           wait(for: [expectation], timeout: 2)
    }
}
