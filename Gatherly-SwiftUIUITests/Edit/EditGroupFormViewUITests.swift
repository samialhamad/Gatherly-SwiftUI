//
//  EditGroupFormViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

final class EditGroupFormViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
        app.segmentedControls.buttons["Groups"].tap()
        
        let groupRow = app.buttons["groupRow-Group Sami Leads"]
        XCTAssertTrue(groupRow.waitForExistence(timeout: 2))
        groupRow.tap()
        
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()
    }
    
    func testEditGroupFormViewLoads() {
        XCTAssertTrue(app.navigationBars["Edit Group"].waitForExistence(timeout: 2))
    }
    
    // MARK: - Save Button
    
    func testSaveButtonIsDisabledWhenNameIsEmpty() {
        let nameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        
        nameField.tap()
        nameField.clearAndEnterText("")
        
        app.navigationBars["Edit Group"].tap() // dismiss keyboard
        app.swipeUp()
        
        let saveButton = app.buttons["saveGroupButton"]
        XCTAssertTrue(saveButton.exists)
        XCTAssertFalse(saveButton.isEnabled)
    }
    
    func testSaveButtonIsEnabledWhenNameIsPopulated() {
        let nameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.clearAndEnterText("Updated Group Name")
        
        app.navigationBars["Edit Group"].tap() // dismiss keyboard
        app.swipeUp()
        
        let saveButton = app.buttons["saveGroupButton"]
        XCTAssertTrue(saveButton.exists)
        XCTAssertTrue(saveButton.isEnabled)
    }
    
    // MARK: - Save / Remove Group
    
    func testSaveGroupUpdatesGroupDetailTitle() {
        let updatedName = "Edited Test Group"
        
        let nameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.clearAndEnterText(updatedName)
        
        app.navigationBars["Edit Group"].tap() // dismiss keyboard
        app.swipeUp()
        
        let saveButton = app.buttons["saveGroupButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        // Wait for navigation back to GroupDetailView
        let updatedNavBar = app.navigationBars[updatedName]
        XCTAssertTrue(updatedNavBar.waitForExistence(timeout: 3))
    }
    
    func testDeletingGroupRemovesItFromGroupsList() {
        let groupName = "Group Sami Leads"

        XCTAssertTrue(app.navigationBars["Edit Group"].waitForExistence(timeout: 2))

        app.swipeUp()
        let deleteButton = app.buttons["deleteGroupButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()

        let deleteAlert = app.alerts["Delete Group?"]
        XCTAssertTrue(deleteAlert.waitForExistence(timeout: 2))
        deleteAlert.buttons["Delete"].tap()

        // Wait for navigation back to GroupsListView
        let groupsNavTitle = app.navigationBars["Groups"]
        XCTAssertTrue(groupsNavTitle.waitForExistence(timeout: 3))

        // Check that the deleted group row no longer exists
        let deletedGroupRow = app.buttons["groupRow-\(groupName)"]
        XCTAssertFalse(deletedGroupRow.waitForExistence(timeout: 2))
    }
    
    // MARK: - Confirmation Dialog
    
    func testDeleteGroupShowsConfirmationDialog() {
        app.swipeUp()
        
        let deleteButton = app.buttons["deleteGroupButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()
        
        let alert = app.alerts["Delete Group?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.buttons["Delete"].exists)
        XCTAssertTrue(alert.buttons["Cancel"].exists)
    }
}
