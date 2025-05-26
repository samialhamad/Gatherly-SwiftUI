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
    
    var builtEvent: Event {
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

        var built = event
        built.plannerID = 1
        built.date = calendar.startOfDay(for: event.date ?? Date())
        built.startTimestamp = Int(mergedStart.timestamp)
        built.endTimestamp = Int(mergedEnd.timestamp)
        built.memberIDs = event.memberIDs?.sorted()
        built.bannerImageName = bannerImageName

        return built
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
