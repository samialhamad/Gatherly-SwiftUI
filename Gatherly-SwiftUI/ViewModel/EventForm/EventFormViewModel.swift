//
//  EventFormViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import Foundation
import SwiftUI

enum EventFormMode {
    case create
    case edit
}

class EventFormViewModel: ObservableObject {
    @Published var event: Event
    @Published var selectedBannerImage: UIImage?
    @Published var selectedDate: Date
    
    // if editing
    private let original: Event?
    let mode: EventFormMode
    
    init(mode: EventFormMode, event: Event? = nil) {
        self.mode = mode
        
        if mode == .edit, let existingEvent = event {
            // if editing initialize from existingEvent
            self.original = existingEvent
            self.event = existingEvent
            
            if let startTimestamp = existingEvent.startTimestamp {
                self.selectedDate = Date.startOfDay(Date(startTimestamp))
            } else {
                self.selectedDate = Date.startOfDay(Date())
            }
            
            if let bannerImageName = existingEvent.bannerImageName {
                self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
            } else {
                self.selectedBannerImage = nil
            }
        } else {
            // if creating initialize a new event
            self.original = nil
            
            let now = Date()
            let nowTimestamp = Int(now.timestamp)
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
            
            self.selectedBannerImage = nil
            self.selectedDate = Date.startOfDay(now)
        }
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
        Date.endTimeRange(for: selectedDate, startTime: startTime)
    }
    
    // MARK: - isFormEmpty
    
    var isFormEmpty: Bool {
        (event.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Create Mode
    
    var builtEvent: Event {
        var built = event
        built.plannerID = SampleData.currentUserID
        built.memberIDs = event.memberIDs?.sorted()
        
        if let bannerImage = selectedBannerImage {
            built.bannerImageName = ImageUtility.saveImageToDocuments(image: bannerImage)
        } else {
            built.bannerImageName = nil
        }
        
        return built
    }
    
    func clearFields() {
        let now = Date()
        let nowTimestamp = Int(now.timestamp)
        
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
        self.selectedBannerImage = nil
        self.selectedDate = Date.startOfDay(now)
    }
    
    // MARK: - Edit Mode
    
    var originalEvent: Event? {
        original
    }
    
    func prepareUpdatedEvent() async -> Event {
        await MainActor.run {
            if let newImage = selectedBannerImage {
                event.bannerImageName = ImageUtility.saveImageToDocuments(image: newImage)
            } else {
                event.bannerImageName = nil
            }
        }
        return event
    }
    
    func removeBannerImage() {
        if let name = event.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: name)
        }
        selectedBannerImage = nil
        event.bannerImageName = nil
    }
    
    var plannerID: Int? {
        event.plannerID
    }
}
