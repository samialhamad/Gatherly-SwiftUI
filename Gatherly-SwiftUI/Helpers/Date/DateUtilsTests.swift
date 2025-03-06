//
//  DateUtilsTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DateUtilsTests: XCTestCase {
    
    func testMerge() {
        let calendar = Calendar.current
        
        let date = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let time = calendar.date(from: DateComponents(hour: 10, minute: 30, second: 0))!
        
        let mergedDate = DateUtils.merge(date: date, time: time)
        let expectedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 30, second: 0))!
        
        XCTAssertEqual(mergedDate, expectedDate)
    }
}
