//
//  GroupsViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GroupsViewModelTests: XCTestCase {
    
//    var viewModel: GroupsViewModel!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        UserDefaultsManager.removeGroups()
//        viewModel = GroupsViewModel()
//    }
//    
//    func makeSampleGroup(id: Int = 100, name: String = "Test Group") -> UserGroup {
//        UserGroup(
//            bannerImageName: "banner.png",
//            id: id,
//            imageName: "img.png",
//            leaderID: 1,
//            memberIDs: [2, 3],
//            messages: [],
//            name: name
//        )
//    }
//    
//    func testLoadIfNeeded_loadsOnlyOnce() {
//        let group = makeSampleGroup(id: 1)
//        UserDefaultsManager.saveGroups([group])
//        
//        let expectation = XCTestExpectation(description: "loadIfNeeded loads once")
//        
//        viewModel.loadIfNeeded()
//        
//        viewModel.$groups
//            .dropFirst()
//            .sink { loadedGroups in
//                XCTAssertEqual(loadedGroups.count, 1)
//                XCTAssertEqual(loadedGroups.first?.id, 1)
//                
//                // Second call shouldn't reload
//                self.viewModel.groups = [] // simulate wipe
//                self.viewModel.loadIfNeeded()
//                XCTAssertEqual(self.viewModel.groups.count, 0, "Should not reload on second call")
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testCreateGroup_addsToList() {
//        let expectation = XCTestExpectation(description: "Group is created and added to list")
//        
//        let group = makeSampleGroup(id: 102, name: "New Group")
//        viewModel.create(group) { createdGroup in
//            XCTAssertNotNil(createdGroup.id)
//            XCTAssertEqual(self.viewModel.groups.count, 1)
//            XCTAssertEqual(self.viewModel.groups.first?.name, "New Group")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testUpdateGroup_replacesCorrectly() {
//        let original = makeSampleGroup(id: 10, name: "Original")
//        UserDefaultsManager.saveGroups([original])
//        
//        let expectation = XCTestExpectation(description: "Group is updated in list")
//        
//        viewModel.fetch()
//        
//        viewModel.$groups
//            .dropFirst()
//            .sink { _ in
//                var updated = original
//                updated.name = "Updated Name"
//                
//                self.viewModel.update(updated)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.groups.first?.name, "Updated Name")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
//    
//    func testDeleteGroup_removesFromList() {
//        let group1 = makeSampleGroup(id: 20)
//        let group2 = makeSampleGroup(id: 21)
//        UserDefaultsManager.saveGroups([group1, group2])
//        
//        let expectation = XCTestExpectation(description: "Group is deleted from list")
//        
//        viewModel.fetch()
//        
//        viewModel.$groups
//            .dropFirst()
//            .sink { _ in
//                self.viewModel.delete(group1)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.groups.count, 1)
//                    XCTAssertEqual(self.viewModel.groups.first?.id, 21)
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
}
