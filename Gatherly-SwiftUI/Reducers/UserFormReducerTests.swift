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
                lastName: "Name",
                mode: .updateCurrentUser
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
                lastName: "Old",
                mode: .updateCurrentUser
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
                lastName: "User",
                mode: .updateCurrentUser
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
                lastName: "User",
                mode: .updateCurrentUser
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setBannerImage(dummyImage)) {
            $0.bannerImage = dummyImage
        }
    }
    
    func testSaveChanges() async throws {
        let initialUser = User(
            avatarImageName: nil,
            bannerImageName: nil,
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Old First",
            friendIDs: nil,
            groupIDs: nil,
            id: 1,
            lastName: "Old Last",
            phone: nil
        )
        
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: initialUser,
                firstName: initialUser.firstName!,
                lastName: initialUser.lastName!,
                avatarImageName: initialUser.avatarImageName,
                bannerImageName: initialUser.bannerImageName,
                avatarImage: nil,
                bannerImage: nil,
                isPresented: false,
                isSaving: false,
                didUpdateUser: false,
                mode: .updateCurrentUser
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.setFirstName("New First")) {
            $0.firstName = "New First"
        }
        await store.send(.setLastName("New Last")) {
            $0.lastName = "New Last"
        }
        
        await store.send(.saveChanges) {
            $0.isSaving = true
        }
        
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let expectedUser = User(
            avatarImageName: nil,
            bannerImageName: nil,
            createdTimestamp: initialUser.createdTimestamp,
            eventIDs: [],
            firstName: "New First",
            friendIDs: nil,
            groupIDs: nil,
            id: 1,
            lastName: "New Last",
            phone: nil
        )
        
        await store.receive(.didSave(expectedUser)) {
            $0.isSaving = false
            $0.didUpdateUser = true
        }
    }
    
    func testCancel() async {
        let store = await TestStore(
            initialState: UserFormReducer.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User",
                isPresented: true,
                mode: .updateCurrentUser
            ),
            reducer: { UserFormReducer() }
        )
        
        await store.send(.cancel) {
            $0.isPresented = false
        }
    }
}
