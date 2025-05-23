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
    
    // MARK: - Init
    
    init() {
        self.event = Event(
            bannerImageName: nil,
            categories: [],
            date: Date(),
            description: "",
            endTimestamp: Int(Date().addingTimeInterval(3600).timestamp),
            location: nil,
            memberIDs: [],
            title: "",
            startTimestamp: Int(Date().timestamp)
        )
    }
    
    // MARK: - Event Creation
    
    func createEvent(plannerID: Int) async -> Event {
        let calendar = Calendar.current
        let mergedStart = Date.merge(
            date: event.date ?? Date(),
            time: Date(timeIntervalSince1970: TimeInterval(event.startTimestamp ?? Int(Date().timestamp)))
        )
        let mergedEnd = Date.merge(
            date: event.date ?? Date(),
            time: Date(timeIntervalSince1970: TimeInterval(event.endTimestamp ?? Int(Date().timestamp + 3600)))
        )
        
        let bannerImageName = selectedBannerImage.flatMap { ImageUtility.saveImageToDocuments(image: $0) }
        
        await MainActor.run {
            event.plannerID = plannerID
            event.date = calendar.startOfDay(for: event.date ?? Date())
            event.startTimestamp = Int(mergedStart.timestamp)
            event.endTimestamp = Int(mergedEnd.timestamp)
            event.memberIDs = event.memberIDs?.sorted()
            event.bannerImageName = bannerImageName
        }
        
        return await withCheckedContinuation { continuation in
            _ = GatherlyAPI.createEvent(event)
                .sink { created in
                    continuation.resume(returning: created)
                }
        }
    }
    
    // MARK: - Helpers
    
    func clearFields() {
        self.event = Event(
            bannerImageName: nil,
            categories: [],
            date: Date(),
            description: "",
            endTimestamp: Int(Date().addingTimeInterval(3600).timestamp),
            location: nil,
            memberIDs: [],
            title: "",
            startTimestamp: Int(Date().timestamp)
        )
        self.selectedBannerImage = nil
    }
    
    var isFormEmpty: Bool {
        (event.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: event.date ?? Date())
    }
    
    var endTimeRange: ClosedRange<Date> {
        Date.endTimeRange(
            for: event.date ?? Date(),
            startTime: Date(timeIntervalSince1970: TimeInterval(event.startTimestamp ?? Int(Date().timestamp)))
        )
    }
}
