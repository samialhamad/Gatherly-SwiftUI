//
//  EventFormViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventFormViewModelTests: XCTestCase {
    
    // MARK: - Helpers
    
    private var fixedDayStart: Date {
        Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5))!
    }
    
    private var fixedStartTime: Date {
        Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5, hour: 10, minute: 0))!
    }
    
    private var fixedEndTime: Date {
        Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5, hour: 12, minute: 0))!
    }
    
    private func makeSampleEvent() -> Event {
        let startTimestamp = Int(fixedStartTime.timestamp)
        let endTimestamp = Int(fixedEndTime.timestamp)
        return Event(
            bannerImageName: nil,
            categories: [.food, .sports],
            description: "Initial description",
            endTimestamp: endTimestamp,
            id: 42,
            plannerID: 99,
            location: nil,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: startTimestamp
        )
    }
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    // MARK: - Create Mode Tests
    
    func testCreateMode_initialValues() {
        let viewModel = EventFormViewModel(mode: .create)
        
        XCTAssertNotNil(viewModel.event.startTimestamp)
        XCTAssertNotNil(viewModel.event.endTimestamp)
        XCTAssertEqual(viewModel.event.categories, [])
        XCTAssertEqual(viewModel.event.memberIDs, [])
        XCTAssertEqual(viewModel.event.title, "")
        XCTAssertEqual(viewModel.event.description, "")
        XCTAssertNil(viewModel.event.bannerImageName)
        XCTAssertNil(viewModel.selectedBannerImage)
        XCTAssertEqual(viewModel.locationName, "")
        
        let expectedDayStart = Date.startOfDay(Date())
        XCTAssertEqual(viewModel.selectedDate, expectedDayStart)
    }
    
    func testIsFormEmpty_inCreateMode() {
        let viewModel = EventFormViewModel(mode: .create)
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "Birthday Party"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    func testStartTime_andEndTime_inCreateMode() {
        let viewModel = EventFormViewModel(mode: .create)
        
        viewModel.selectedDate = fixedDayStart
        
        // startTime should merge into event.startTimestamp
        viewModel.startTime = fixedStartTime
        let mergedStart = Date.merge(date: fixedDayStart, time: fixedStartTime)
        XCTAssertEqual(viewModel.event.startTimestamp, Int(mergedStart.timestamp))
        XCTAssertEqual(viewModel.startTime, mergedStart)
        
        // endTime should merge into event.endTimestamp
        viewModel.endTime = fixedEndTime
        let mergedEnd = Date.merge(date: fixedDayStart, time: fixedEndTime)
        XCTAssertEqual(viewModel.event.endTimestamp, Int(mergedEnd.timestamp))
        XCTAssertEqual(viewModel.endTime, mergedEnd)
    }
    
    func testStartTime_whenTimestampIsNil_returnsNow_inCreateMode() {
        let viewModel = EventFormViewModel(mode: .create)
        viewModel.event.startTimestamp = nil
        
        let startTime = viewModel.startTime
        // abs since timeIntervalSinceNow can be negative, 1 second window
        XCTAssertLessThan(abs(startTime.timeIntervalSinceNow), 1.0)
    }
    
    func testStartTime_bumpsEndTime_whenPastExistingEndTime_inCreateMode() {
        let viewModel = EventFormViewModel(mode: .create)
        viewModel.selectedDate = fixedDayStart

        let endTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: fixedDayStart)!
        viewModel.endTime = endTime

        // move startTime past that
        let newStartTime = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: fixedDayStart)!
        viewModel.startTime = newStartTime

        let merged = Date.merge(date: fixedDayStart, time: newStartTime)
        XCTAssertEqual(viewModel.startTime, merged)
        // endTime should have been bumped to match
        XCTAssertEqual(viewModel.endTime, merged)
    }
    
    func testEndTime_whenTimestampIsNil_returnsNow_inCreateMode() {
        let viewModel = EventFormViewModel(mode: .create)
        viewModel.event.endTimestamp = nil
        
        let endTime = viewModel.endTime
        XCTAssertLessThan(abs(endTime.timeIntervalSinceNow), 1.0)
    }
    
    func testBuiltEvent() {
        let viewModel = EventFormViewModel(mode: .create)
        
        viewModel.event.title = "Test Event"
        viewModel.event.description = "Test description"
        viewModel.selectedDate = fixedDayStart
        viewModel.event.startTimestamp = Int(fixedStartTime.timestamp)
        viewModel.event.endTimestamp = Int(fixedEndTime.timestamp)
        viewModel.event.memberIDs = [3, 2]
        viewModel.event.categories = [.education, .networking]
        
        let dummyImage = UIImage(systemName: "star.fill")!
        viewModel.selectedBannerImage = dummyImage
        
        let builtEvent = viewModel.builtEvent
        
        XCTAssertEqual(builtEvent.title, "Test Event")
        XCTAssertEqual(builtEvent.description, "Test description")
        XCTAssertEqual(builtEvent.date, Calendar.current.startOfDay(for: fixedDayStart))
        XCTAssertEqual(builtEvent.startTimestamp, Int(fixedStartTime.timestamp))
        XCTAssertEqual(builtEvent.endTimestamp, Int(fixedEndTime.timestamp))
        XCTAssertEqual(builtEvent.plannerID, SampleData.currentUserID)
        XCTAssertEqual(builtEvent.memberIDs, [2, 3])
        XCTAssertEqual(builtEvent.categories, [.education, .networking])
        XCTAssertNotNil(builtEvent.bannerImageName)
    }
    
    func testClearFields() {
        let viewModel = EventFormViewModel(mode: .create)
        
        viewModel.event.title = "Something"
        viewModel.event.description = "Something"
        viewModel.event.memberIDs = [1, 2, 3]
        viewModel.event.categories = [.travel, .networking]
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!
        viewModel.selectedDate = fixedDayStart
        
        viewModel.clearFields()
        
        XCTAssertEqual(viewModel.event.title, "")
        XCTAssertEqual(viewModel.event.description, "")
        XCTAssertEqual(viewModel.event.memberIDs, [])
        XCTAssertEqual(viewModel.event.categories, [])
        XCTAssertEqual(viewModel.locationName, "")
        XCTAssertNil(viewModel.selectedBannerImage)
        
        let expectedDayStart = Date.startOfDay(Date())
        XCTAssertEqual(viewModel.selectedDate, expectedDayStart)
    }
    
    // MARK: - Edit Mode Tests
    
    func testEditMode_initialValues() {
        var sampleEvent = makeSampleEvent()
        sampleEvent.bannerImageName = "nonexistent.jpg"
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        XCTAssertEqual(viewModel.event, sampleEvent)
        
        XCTAssertEqual(viewModel.event.id, sampleEvent.id)
        XCTAssertEqual(viewModel.event.plannerID, sampleEvent.plannerID)
        XCTAssertEqual(viewModel.event.memberIDs, sampleEvent.memberIDs)
        XCTAssertEqual(viewModel.event.categories, sampleEvent.categories)
        
        let expectedSelected = Date.startOfDay(Date(sampleEvent.startTimestamp!))
        XCTAssertEqual(viewModel.selectedDate, expectedSelected)
        
        XCTAssertNil(viewModel.selectedBannerImage)
    }
    
    func testIsFormEmpty_inEditMode() {
        let sampleEvent = makeSampleEvent()
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        XCTAssertFalse(viewModel.isFormEmpty)
        
        viewModel.event.title = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "Updated Title"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    func testStartTime_andEndTime_inEditMode() {
        var sampleEvent = makeSampleEvent()
        // override start and end timestamps to
        let startTimestamp = Int(fixedStartTime.timestamp)
        let endTimestamp = Int(fixedEndTime.timestamp)
        sampleEvent.startTimestamp = startTimestamp
        sampleEvent.endTimestamp = endTimestamp
        
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        // selectedDate should be the day of fixedStartTime
        let expectedDayStart = Calendar.current.startOfDay(for: fixedStartTime)
        XCTAssertEqual(viewModel.selectedDate, expectedDayStart)
        
        XCTAssertEqual(viewModel.startTime, fixedStartTime)
        XCTAssertEqual(viewModel.endTime, fixedEndTime)
        
        let newStart = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: fixedDayStart)!
        let newEnd = Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: fixedDayStart)!
        
        viewModel.startTime = newStart
        let mergedStart = Date.merge(date: fixedDayStart, time: newStart)
        
        XCTAssertEqual(viewModel.event.startTimestamp, Int(mergedStart.timestamp))
        XCTAssertEqual(viewModel.startTime, mergedStart)
        
        viewModel.endTime = newEnd
        let mergedEnd = Date.merge(date: fixedDayStart, time: newEnd)
        
        XCTAssertEqual(viewModel.event.endTimestamp, Int(mergedEnd.timestamp))
        XCTAssertEqual(viewModel.endTime, mergedEnd)
    }
    
    func testStartTime_whenTimestampIsNil_returnsNow_inEditMode() {
        var sampleEvent = makeSampleEvent()
        sampleEvent.startTimestamp = nil
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        let startTime = viewModel.startTime
        XCTAssertLessThan(abs(startTime.timeIntervalSinceNow), 1.0)
    }
    
    func testStartTime_bumpsEndTime_whenPastExistingEndTime_inEditMode() async {
        var event = makeSampleEvent()
        event.startTimestamp = Int(fixedStartTime.timestamp)
        event.endTimestamp   = Int(fixedEndTime.timestamp)
        let viewModel = EventFormViewModel(mode: .edit(event: event))
        viewModel.selectedDate = fixedDayStart

        // move start time past end time
        let newStartTime = Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: fixedDayStart)!
        viewModel.startTime = newStartTime

        let merged = Date.merge(date: fixedDayStart, time: newStartTime)
        XCTAssertEqual(viewModel.startTime, merged)
        // endTime should now be bumped
        XCTAssertEqual(viewModel.endTime, merged)
    }
    
    func testEndTime_whenTimestampIsNil_returnsNow_inEditMode() {
        var sampleEvent = makeSampleEvent()
        sampleEvent.endTimestamp = nil
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        let endTime = viewModel.endTime
        XCTAssertLessThan(abs(endTime.timeIntervalSinceNow), 1.0)
    }
    
    func testPrepareUpdatedEvent_updatesBannerImage_inEditMode() async {
        var sampleEvent = makeSampleEvent()
        sampleEvent.bannerImageName = nil
        
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        let dummyImage = UIImage(systemName: "star.fill")!
        viewModel.selectedBannerImage = dummyImage
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertNotNil(updatedEvent.bannerImageName)
    }
    
    func testPrepareUpdatedEvent_clearsBannerImage_ifNoNewSelection_inEditMode() async {
        var sampleEvent = makeSampleEvent()
        sampleEvent.bannerImageName = "dummy_banner.jpg"
        
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertNil(updatedEvent.bannerImageName)
    }
    
    func testRemoveBannerImage_clearsBothStoredName_andSelectedImage_inEditMode() {
        var sampleEvent = makeSampleEvent()
        sampleEvent.bannerImageName = "toBeDeleted.jpg"
        
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!
        viewModel.event.bannerImageName = "toBeDeleted.jpg"
        
        viewModel.removeBannerImage()
        
        XCTAssertNil(viewModel.selectedBannerImage)
        XCTAssertNil(viewModel.event.bannerImageName)
    }
    
    func testPlannerID_reflectsEventPlannerID_inEditMode() {
        let sampleEvent = makeSampleEvent()
        let viewModel = EventFormViewModel(mode: .edit(event: sampleEvent))
        
        XCTAssertEqual(viewModel.plannerID, sampleEvent.plannerID)
    }
}
