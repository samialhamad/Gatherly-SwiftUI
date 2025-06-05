//
//  EditEventViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation
import SwiftUI

class EditEventViewModel: ObservableObject {
    @Published var event: Event
    @Published var selectedBannerImage: UIImage?
    @Published var selectedDate: Date
    
    private let original: Event
    
    var originalEvent: Event {
        original
    }
    
    init(event: Event) {
        self.original = event
        self.event = event
        
        if let timestamp = event.startTimestamp {
            let startDate = Date(timestamp)
            self.selectedDate = Date.startOfDay(startDate)
        } else {
            let now = Date()
            self.selectedDate = Date.startOfDay(now)
        }
        
        if let imageName = event.bannerImageName {
            self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: imageName)
        } else {
            self.selectedBannerImage = nil
        }
    }
    
    // MARK: - Update Logic
    
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
    
    // MARK: - Helpers
    
    func removeBannerImage() {
        if let imageName = event.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: imageName)
        }
        selectedBannerImage = nil
        event.bannerImageName = nil
    }
    
    var isFormEmpty: Bool {
        (event.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var plannerID: Int? {
        event.plannerID
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
