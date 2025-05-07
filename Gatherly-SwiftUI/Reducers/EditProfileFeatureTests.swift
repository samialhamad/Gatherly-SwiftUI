//
//  EditProfileFeatureTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/2/25.
//

import XCTest
import ComposableArchitecture
@testable import Gatherly_SwiftUI

final class EditProfileFeatureTests: XCTestCase {
    
    func testSetFirstName() async {
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: User(firstName: "Old", id: 1, lastName: "Name"),
                firstName: "Old",
                lastName: "Name"
            ),
            reducer: { EditProfileFeature() }
        )

        await store.send(.setFirstName("New")) {
            $0.firstName = "New"
        }
    }
    
    func testSetLastName() async {
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: User(firstName: "Test", id: 1, lastName: "Old"),
                firstName: "Test",
                lastName: "Old"
            ),
            reducer: { EditProfileFeature() }
        )

        await store.send(.setLastName("New")) {
            $0.lastName = "New"
        }
    }
    
    func testSetAvatarImage() async {
        let dummyImage = UIImage(systemName: "person")!
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User"
            ),
            reducer: { EditProfileFeature() }
        )

        await store.send(.setAvatarImage(dummyImage)) {
            $0.avatarImage = dummyImage
        }
    }

    func testSetBannerImage() async {
        let dummyImage = UIImage(systemName: "photo")!
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User"
            ),
            reducer: { EditProfileFeature() }
        )

        await store.send(.setBannerImage(dummyImage)) {
            $0.bannerImage = dummyImage
        }
    }
    
    func testSaveChanges_updatesUser() async {
        let originalUser = User(firstName: "Sami", id: 1, lastName: "Alhamad")
        
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: originalUser,
                firstName: "New",
                lastName: "Name"
            ),
            reducer: { EditProfileFeature() }
        )
        
        await store.send(.saveChanges)

        XCTAssertEqual(store.state.currentUser.firstName, "New")
        XCTAssertEqual(store.state.currentUser.lastName, "Name")
    }
    
    func testCancel() async {
        let store = await TestStore(
            initialState: EditProfileFeature.State(
                currentUser: User(id: 1),
                firstName: "Test",
                lastName: "User",
                isPresented: true
            ),
            reducer: { EditProfileFeature() }
        )
        
        await store.send(.cancel) {
            $0.isPresented = false
        }
    }
}
