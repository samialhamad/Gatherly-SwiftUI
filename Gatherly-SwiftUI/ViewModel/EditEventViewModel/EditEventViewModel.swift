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
    
    private let original: Event
    
    var originalEvent: Event {
        original
    }
    
    init(event: Event) {
        self.original = event
        self.event = event
        
        if let imageName = event.bannerImageName {
            self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: imageName)
        }
    }
    
    // MARK: - Update Logic
    
    func updateEvent() async -> Event {
        await MainActor.run {
            if let newImage = selectedBannerImage {
                event.bannerImageName = ImageUtility.saveImageToDocuments(image: newImage)
            } else {
                event.bannerImageName = nil
            }
        }
        
        return await GatherlyAPI.updateEvent(event)
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
    
    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: event.date ?? Date())
    }
    
    var endTimeRange: ClosedRange<Date> {
        let start = event.startTimestamp.map { Date(timeIntervalSince1970: TimeInterval($0)) } ?? Date()
        return Date.endTimeRange(for: event.date ?? Date(), startTime: start)
    }
    
    var plannerID: Int? {
        event.plannerID
    }
}
