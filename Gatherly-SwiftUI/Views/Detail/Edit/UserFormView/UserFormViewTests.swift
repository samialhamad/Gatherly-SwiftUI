//
//  UserFormViewTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserFormViewTests: XCTestCase {

    typealias Mode = UserFormReducer.State.Mode

    func testNavigationTitleCreateFriend() {
        let mode: Mode = .createFriend
        let title = UserFormView.navigationTitle(for: mode)

        XCTAssertEqual(title, Constants.UserFormView.createFriendString)
    }

    func testNavigationTitleUpdateCurrentUser() {
        let mode: Mode = .updateCurrentUser
        let title = UserFormView.navigationTitle(for: mode)

        XCTAssertEqual(title, Constants.UserFormView.updateCurrentUserString)
    }

    func testNavigationTitleUpdateFriend() {
        let mode: Mode = .updateFriend
        let title = UserFormView.navigationTitle(for: mode)

        XCTAssertEqual(title, Constants.UserFormView.updateFriendString)
    }
}
