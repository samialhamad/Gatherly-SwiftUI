//
//  CreateEventViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation
import SwiftUI

class CreateEventViewModel: ObservableObject {
    @Published var event: Event
    @Published var selectedBannerImage: UIImage?
    @Published var selectedDate: Date
    
    // MARK: - Init
    
    init() {
        let today = Date()
        let nowTimestamp = Int(today.timestamp)
        
        self.event = Event(
            bannerImageName: nil,
            categories: [],
            description: "",
            endTimestamp: nowTimestamp,
            location: nil,
            memberIDs: [],
            title: "",
            startTimestamp: nowTimestamp
        )
        
        self.selectedDate = Date.startOfDay(today)
    }
    
    // MARK: - Event Creation
    
    var builtEvent: Event {
        var built = event
        built.plannerID = SampleData.currentUserID
        
        built.memberIDs = event.memberIDs?.sorted()
        
        if let image = selectedBannerImage {
            built.bannerImageName = ImageUtility.saveImageToDocuments(image: image)
        } else {
            built.bannerImageName = nil
        }
        
        return built
    }
    
    // MARK: - Helpers
    
    func clearFields() {
        let now = Date()
        let nowTimestamp = Int(now.timestamp)
        let defaultEndTimestamp = Int((now.plus(calendarComponent: .hour, value: 1)?.timestamp) ?? now.timestamp)

        self.event = Event(
            bannerImageName: nil,
            categories: [],
            description: "",
            endTimestamp: defaultEndTimestamp,
            location: nil,
            memberIDs: [],
            title: "",
            startTimestamp: nowTimestamp
        )
        self.selectedBannerImage = nil
        self.selectedDate = Date.startOfDay(now)
    }
    
    var isFormEmpty: Bool {
        (event.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Time & Ranges
    
    var startTime: Date {
        get {
            guard let timestamp = event.startTimestamp else {
                return Date()
            }
            
            return Date(timestamp)
        }
        set {
            let merged = Date.merge(date: selectedDate, time: newValue)
            event.startTimestamp = Int(merged.timestamp)
        }
    }
    
    var endTime: Date {
        get {
            guard let timestamp = event.endTimestamp else {
                return Date()
            }
            
            return Date(timestamp)
        }
        set {
            let merged = Date.merge(date: selectedDate, time: newValue)
            event.endTimestamp = Int(merged.timestamp)
        }
    }
    
    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: selectedDate)
    }
    
    var endTimeRange: ClosedRange<Date> {
        Date.endTimeRange(
            for: selectedDate,
            startTime: startTime
        )
    }
}
