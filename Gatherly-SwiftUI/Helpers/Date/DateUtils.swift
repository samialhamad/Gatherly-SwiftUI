//
//  DateUtils.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation

struct DateUtils {
    static func merge(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents) ?? time
    }
    
    static func startTimeRange(for selectedDate: Date) -> ClosedRange<Date> {
        let now = Date()
        let calendar = Calendar.current
        if calendar.isDate(selectedDate, inSameDayAs: now) {
            let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now)!
            return now...dayEnd
        } else {
            let dayStart = calendar.startOfDay(for: selectedDate)
            let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!
            return dayStart...dayEnd
        }
    }
    
    static func endTimeRange(for selectedDate: Date, startTime: Date) -> ClosedRange<Date> {
        let now = Date()
        let calendar = Calendar.current
        if calendar.isDate(selectedDate, inSameDayAs: now) {
            let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now)!
            let lowerBound = max(startTime, now)
            return lowerBound...dayEnd
        } else {
            let dayStart = calendar.startOfDay(for: selectedDate)
            let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!
            return dayStart...dayEnd
        }
    }
}

