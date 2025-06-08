//
//  EventFormViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import Foundation
import SwiftUI

class EventFormViewModel: ObservableObject {
    @Published var event: Event
    @Published var selectedBannerImage: UIImage?
    @Published var selectedDate: Date
    @Published var locationName: String
    
    let mode: Mode
    
    enum Mode: Equatable {
        case create
        case edit(event: Event)
    }
    
    init(mode: Mode, event: Event? = nil) {
        self.mode = mode
        
        switch mode {
        case .create:
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
            self.locationName = ""
            self.selectedBannerImage = nil
            self.selectedDate = Date.startOfDay(now)
            
        case .edit(let event):
            self.event = event
            self.locationName = event.location?.name ?? ""
            
            if let startTimestamp = event.startTimestamp {
                self.selectedDate = Date.startOfDay(Date(startTimestamp))
            } else {
                self.selectedDate = Date.startOfDay(Date())
            }
            
            if let bannerImageName = event.bannerImageName {
                self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
            } else {
                self.selectedBannerImage = nil
            }
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
            let newStartTime = Int(merged.timestamp)
            event.startTimestamp = newStartTime
            
            if (event.endTimestamp ?? 0) < newStartTime {
                  event.endTimestamp = newStartTime
            }
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
        self.locationName = ""
        self.selectedBannerImage = nil
        self.selectedDate = Date.startOfDay(now)
    }
    
    // MARK: - Edit Mode
    
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
        if let bannerImageName = event.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: bannerImageName)
        }
        selectedBannerImage = nil
        event.bannerImageName = nil
    }
    
    var plannerID: Int? {
        event.plannerID
    }
}
