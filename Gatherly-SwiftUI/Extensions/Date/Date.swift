//
//  Date.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation

extension Date {
    
    //MARK: - Timestamp
    
    public init(_ timestamp: Int) {
        self.init(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    public var timestamp: Int {
        return Int(timeIntervalSince1970)
    }
    
    public var dayTimestamp: Int? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        
        let day = calendar.date(from: components)
        return day?.timestamp
    }
    
    //MARK: - startOfDay
    
    public static func startOfDay(_ date: Date?) -> Date {
        guard let date = date else {
            return Date()  // fallback if nil
        }
        return Calendar.current.startOfDay(for: date)
    }
    
    //MARK: - Plus / Minus
    
    public func plus(
        calendarComponent: Calendar.Component,
        value: Int
    ) -> Date? {
        return Calendar.current.date(
            byAdding: calendarComponent,
            value: value,
            to: self
        )
    }
    
    public func minus(
        calendarComponent: Calendar.Component,
        value: Int
    ) -> Date? {
        let value = -value
        return Calendar.current.date(
            byAdding: calendarComponent,
            value: value,
            to: self
        )
    }
    
    //MARK: - Between
    
    public static func yearsBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year],
                                                 from: date1,
                                                 to: date2)
        return components.year!
    }
    
    public static func monthsBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month],
                                                 from: date1,
                                                 to: date2)
        return components.month!
    }
    
    public static func weeksBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear],
                                                 from: date1,
                                                 to: date2)
        return components.weekOfYear!
    }
    
    public static func daysBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day],
                                                 from: date1,
                                                 to: date2)
        return components.day!
    }
    
    public static func hoursBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour],
                                                 from: date1,
                                                 to: date2)
        return components.hour!
    }
    
    public static func minutesBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute],
                                                 from: date1,
                                                 to: date2)
        return components.minute!
    }
    
    public static func secondsBetween(_ date1: Date, _ date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second],
                                                 from: date1,
                                                 to: date2)
        return components.second!
    }
    
    //MARK: - Same
    
    public static func isSameDay(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs:date2)
    }
    
    // MARK: - Merge
    
    public static func merge(date: Date, time: Date) -> Date {
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
    
    // MARK: - Range
    
    public static func startTimeRange(for selectedDate: Date) -> ClosedRange<Date> {
        let now = Date()
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: selectedDate)
        let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!

        if calendar.isDateInToday(selectedDate) {
            let lowerBound = max(dayStart, now)
            return lowerBound...dayEnd
        } else {
            return dayStart...dayEnd
        }
    }
    
    public static func endTimeRange(for selectedDate: Date, startTime: Date) -> ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        
        let dayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!
        
        var lowerBound = startTime
        
        if calendar.isDateInToday(selectedDate) {
            lowerBound = max(startTime, now)
        }
        
        if lowerBound > dayEnd {
            lowerBound = dayEnd
        }
        
        return lowerBound...dayEnd
    }
    
    //MARK: - Time String
    
    public static func timeString(date1: Date, date2: Date) -> String {
        let secondsBetween = Date.secondsBetween(date1, date2)
        
        let days = secondsBetween / 86400
        let hours = secondsBetween / 3600
        let minutes = secondsBetween / 60 % 60
        let seconds = secondsBetween % 60
        
        switch hours {
        case 24...:
            let format = "%id"
            return String(format:format, days)
        case 10..<24:
            let format = "%02i:%02i:%02i"
            return String(format:format, hours, minutes, seconds)
        case 1..<10:
            let format = "%01i:%02i:%02i"
            return String(format:format, hours, minutes, seconds)
        case ..<1:
            let format = "%02i:%02i"
            return String(format:format, minutes, seconds)
        default:
            return ""
        }
    }
}
