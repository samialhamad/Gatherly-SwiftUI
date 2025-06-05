//
//  DateUtilsTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DateTests: XCTestCase {
    
    // MARK: - Timestamp
    
    func testTimestamp() {
        let timestamp = 780192000
        let date = Date(timestamp)
        XCTAssertEqual(date.timestamp, timestamp)
    }
    
    func testDayTimestamp() {
        let timestamp = 780192000
        let date = Date(timestamp)
        let dayTimestamp = date.dayTimestamp
        XCTAssertEqual(780130800, dayTimestamp)
    }
    
    // MARK: - startOfDay
    
    func testStartOfDay() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2025, month: 3, day: 5, hour: 15, minute: 30, second: 0)
        guard let sampleDate = calendar.date(from: components) else {
            XCTFail("Failed to create sample date")
            return
        }
        
        let result = Date.startOfDay(sampleDate)
        let expected = calendar.startOfDay(for: sampleDate)
        
        XCTAssertEqual(result, expected)
    }
    
    // MARK: - Plus / Minus + Between
    
    //years
    
    func testDatePlusYearsAndYearsBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .year, value: 3)!
        let yearsBetween = Date.yearsBetween(date1, date2)
        XCTAssertEqual(yearsBetween, 3)
    }
    
    func testDateMinusYearsAndYearsBetween() {
        let date1 = Date().minus(calendarComponent: .year, value: 3)!
        let date2 = Date()
        let yearsBetween = Date.yearsBetween(date1, date2)
        XCTAssertEqual(yearsBetween, 3)
    }
    
    //months
    
    func testDatePlusMonthsAndMonthsBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .month, value: 6)!
        let monthsBetween = Date.monthsBetween(date1, date2)
        XCTAssertEqual(monthsBetween, 6)
    }
    
    func testDateMinusMonthsAndMonthsBetween() {
        let date1 = Date().minus(calendarComponent: .month, value: 6)!
        let date2 = Date()
        let monthsBetween = Date.monthsBetween(date1, date2)
        XCTAssertEqual(monthsBetween, 6)
    }
    
    //weeks
    
    func testDatePlusWeeksAndWeeksBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .weekOfYear, value: 1)!
        let weeksBetween = Date.weeksBetween(date1, date2)
        XCTAssertEqual(weeksBetween, 1)
    }
    
    func testDateMinusWeeksAndWeeksBetween() {
        let date1 = Date().minus(calendarComponent: .weekOfYear, value: 1)!
        let date2 = Date()
        let weeksBetween = Date.weeksBetween(date1, date2)
        XCTAssertEqual(weeksBetween, 1)
    }
    
    //days
    
    func testDatePlusDaysAndDaysBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .day, value: 4)!
        let daysBetween = Date.daysBetween(date1, date2)
        XCTAssertEqual(daysBetween, 4)
    }
    
    func testDateMinusDaysAndDaysBetween() {
        let date1 = Date().minus(calendarComponent: .day, value: 4)!
        let date2 = Date()
        let daysBetween = Date.daysBetween(date1, date2)
        XCTAssertEqual(daysBetween, 4)
    }
    
    //hours
    
    func testDatePlusHoursAndHoursBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .hour, value: 2)!
        let hoursBetween = Date.hoursBetween(date1, date2)
        XCTAssertEqual(hoursBetween, 2)
    }
    
    func testDateMinusHoursAndHoursBetween() {
        let date1 = Date().minus(calendarComponent: .hour, value: 2)!
        let date2 = Date()
        let hoursBetween = Date.hoursBetween(date1, date2)
        XCTAssertEqual(hoursBetween, 2)
    }
    
    //minutes
    
    func testDatePlusMinutesAndMinutesBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .minute, value: 2)!
        let minutesBetween = Date.minutesBetween(date1, date2)
        XCTAssertEqual(minutesBetween, 2)
    }
    
    func testDateMinusMinutesAndMinutesBetween() {
        let date1 = Date().minus(calendarComponent: .minute, value: 2)!
        let date2 = Date()
        let minutesBetween = Date.minutesBetween(date1, date2)
        XCTAssertEqual(minutesBetween, 2)
    }
    
    //seconds
    
    func testDatePlusSecondsAndSecondsBetween() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .second, value: 30)!
        let secondsBetween = Date.secondsBetween(date1, date2)
        XCTAssertEqual(secondsBetween, 30)
    }
    
    func testDateMinusSecondsAndSecondsBetween() {
        let date1 = Date().minus(calendarComponent: .second, value: 30)!
        let date2 = Date()
        let secondsBetween = Date.secondsBetween(date1, date2)
        XCTAssertEqual(secondsBetween, 30)
    }
    
    // MARK: - Same
    
    func testIsSameDay() {
        let date1 = Date()
        let date2 = Date()
        let date3 = Date().minus(calendarComponent: .year, value: 3)!
        
        XCTAssertTrue(Date.isSameDay(date1: date1, date2: date2))
        XCTAssertFalse(Date.isSameDay(date1: date1, date2: date3))
    }
    
    // MARK: - Merge
    
    func testMerge() {
        let calendar = Calendar.current
        
        let date = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let time = calendar.date(from: DateComponents(hour: 10, minute: 30, second: 0))!
        
        let mergedDate = Date.merge(date: date, time: time)
        let expectedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 30, second: 0))!
        
        XCTAssertEqual(mergedDate, expectedDate)
    }
    
    // MARK: - Range
    
    func testStartTimeRange_notTodayDate() {
        let calendar = Calendar.current
        var components = DateComponents(year: 2025, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        guard let sampleDate = calendar.date(from: components) else {
            XCTFail("Failed to create sample date")
            return
        }
        
        let range = Date.startTimeRange(for: sampleDate)
        
        let expectedStartOfDay = calendar.startOfDay(for: sampleDate)
        let expectedDayEnd = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: sampleDate
        )!
        
        XCTAssertEqual(range.lowerBound, expectedStartOfDay)
        XCTAssertEqual(range.upperBound, expectedDayEnd)
    }
    
    func testEndTimeRange_notTodayDate_startTimeBeforeDayEnd() {
        let calendar = Calendar.current
        var components = DateComponents(year: 2025, month: 1, day: 1, hour: 10, minute: 0, second: 0)
        guard let sampleDate = calendar.date(from: components) else {
            XCTFail("Failed to create sample date")
            return
        }
        
        let startTime = calendar.date(from: DateComponents(
            year: 2025, month: 1, day: 1, hour: 10, minute: 0, second: 0
        ))!
        
        let range = Date.endTimeRange(for: sampleDate, startTime: startTime)
        
        let expectedDayEnd = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: sampleDate
        )!
        
        XCTAssertEqual(range.lowerBound, startTime)
        XCTAssertEqual(range.upperBound, expectedDayEnd)
    }
    
    func testEndTimeRange_notTodayDate_startTimeAfterDayEnd() {
        let calendar = Calendar.current
        var components = DateComponents(year: 2025, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        guard let sampleDate = calendar.date(from: components) else {
            XCTFail("Failed to create sample date")
            return
        }
        
        let afterEndDate = calendar.date(from: DateComponents(
            year: 2025, month: 1, day: 2, hour: 0, minute: 0, second: 1
        ))!
        
        let range = Date.endTimeRange(for: sampleDate, startTime: afterEndDate)
        
        let expectedDayEnd = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: sampleDate
        )!
        
        XCTAssertEqual(range.lowerBound, expectedDayEnd)
        XCTAssertEqual(range.upperBound, expectedDayEnd)
    }
    
    func testStartTimeRange_today() {
        let calendar = Calendar.current
        let beforeCalling = Date()
        let range = Date.startTimeRange(for: beforeCalling)
        
        let expectedDayEnd = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: beforeCalling
        )!
        
        XCTAssertTrue(range.lowerBound >= beforeCalling)
        XCTAssertEqual(range.upperBound, expectedDayEnd)
    }
    
    func testEndTimeRange_today_withStartTimeBeforeNow() {
        let calendar = Calendar.current
        let beforeCalling = Date()
        let startOfDay = calendar.startOfDay(for: beforeCalling)
        let range = Date.endTimeRange(for: beforeCalling, startTime: startOfDay)
        
        let expectedDayEnd = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: beforeCalling
        )!
        
        XCTAssertTrue(range.lowerBound >= beforeCalling)
        XCTAssertEqual(range.upperBound, expectedDayEnd)
    }
    
    // MARK: - Time String
    
    //    func testTimeString10Days() {
    //        let date1 = Date()
    //        let date2 = Date().plus(calendarComponent: .day, value: 10)!
    //
    //        let timeString = Date.timeString(date1: date1, date2: date2)
    //        let expectedTimeString = "10d"
    //        XCTAssertEqual(timeString, expectedTimeString)
    //    }
    
    func testTimeString1Day() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .day, value: 1)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "1d"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString10Hours() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .hour, value: 10)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "10:00:00"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString9Hours() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .hour, value: 9)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "9:00:00"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString2Hours() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .hour, value: 2)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "2:00:00"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString1Hour() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .hour, value: 1)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "1:00:00"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString30Minutes() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .minute, value: 30)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "30:00"
        XCTAssertEqual(timeString, expectedTimeString)
    }
    
    func testTimeString8Seconds() {
        let date1 = Date()
        let date2 = Date().plus(calendarComponent: .second, value: 8)!
        
        let timeString = Date.timeString(date1: date1, date2: date2)
        let expectedTimeString = "00:08"
        XCTAssertEqual(timeString, expectedTimeString)
    }
}
