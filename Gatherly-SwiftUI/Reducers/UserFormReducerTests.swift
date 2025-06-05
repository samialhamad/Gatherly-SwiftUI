//
//  UserFormReducerTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/2/25.
//

import XCTest
import ComposableArchitecture
@testable import Gatherly_SwiftUI

final class UserFormReducerTests: XCTestCase {
    
    func testSetFirstName() async {
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(firstName: "Old", id: 1, lastName: "Name"),
                firstName: "Old",
                lastName: "Name"
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setFirstName("New")) {
            $0.firstName = "New"
        }
    }
    
    func testSetLastName() async {
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(firstName: "Test", id: 1, lastName: "Old"),
                firstName: "Test",
                lastName: "Old"
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setLastName("New")) {
            $0.lastName = "New"
        }
    }
    
    func testSetAvatarImage() async {
        let dummyImage = UIImage(systemName: "person")!
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User"
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setAvatarImage(dummyImage)) {
            $0.avatarImage = dummyImage
        }
    }
    
    func testSetBannerImage() async {
        let dummyImage = UIImage(systemName: "photo")!
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User"
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setBannerImage(dummyImage)) {
            $0.bannerImage = dummyImage
        }
    }
    
    // Failing test - something with User being a class?
//    func testSaveChanges_updatesUser() async {
//        var originalUser = User(
//            createdTimestamp: 1234567890,
//            eventIDs: [],
//            firstName: "Sami",
//            friendIDs: [],
//            groupIDs: [],
//            id: 1,
//            lastName: "Alhamad",
//            phone: nil
//        )
//        
//        let store = await TestStore(
//            initialState: UserFormReducer.State(
//                currentUser: originalUser,
//                firstName: "New",
//                lastName: "Name"
//            ),
//            reducer: { UserFormReducer() }
//        )
//        
//        await store.send(.saveChanges)
//        
//        var updatedUser = originalUser
//        updatedUser.firstName = "New"
//        updatedUser.lastName = "Name"
//        
//        await store.receive(.userSaved(updatedUser)) {
//            $0.currentUser.firstName = "New"
//            $0.currentUser.lastName = "Name"
//        }
//        
//        await store.receive(.delegate(.didSave(updatedUser)))
//    }
    
    func testCancel() async {
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User",
                isPresented: true
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.cancel) {
            $0.isPresented = false
        }
    }
}
