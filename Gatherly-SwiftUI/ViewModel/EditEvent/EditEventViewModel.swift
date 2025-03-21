//
//  EditEventViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation
import SwiftUI

class EditEventViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var selectedDate: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var selectedMemberIDs: Set<Int>
    @Published var location: Location?
    @Published var locationName: String
    @Published var selectedCategories: [Brand.EventCategory]
    @Published var selectedBannerImage: UIImage?
    
    private let original: Event
    
    var originalEvent: Event {
        original
    }
    
    init(event: Event) {
        self.original = event
        
        self.title = event.title ?? ""
        self.description = event.description ?? ""
        self.selectedDate = event.date ?? Date()
        self.startTime = event.startTimestamp != nil ? Date(timeIntervalSince1970: TimeInterval(event.startTimestamp!)) : Date()
        self.endTime = (event.endTimestamp != nil ? Date(timeIntervalSince1970: TimeInterval(event.endTimestamp!)) : Date().plus(calendarComponent: .hour, value: 1)) ?? Date()
        self.selectedMemberIDs = Set(event.memberIDs ?? [])
        self.location = event.location
        self.locationName = event.location?.name ?? ""
        self.selectedCategories = event.categories
        
        if let imageName = event.bannerImageName {
            self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: imageName)
        }
    }
    
    func updatedEvent() -> Event {
        var bannerImageName: String? = originalEvent.bannerImageName // original default, for now
        
        if let newImage = selectedBannerImage {
            bannerImageName = ImageUtility.saveImageToDocuments(image: newImage)
        }
        
        return EventEditor.saveEvent(
            originalEvent: originalEvent,
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs,
            plannerID: originalEvent.plannerID ?? 0,
            location: location,
            categories: selectedCategories,
            bannerImageName: bannerImageName
        )
    }
    
    func removeBannerImage() {
        if let imageName = originalEvent.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: imageName)
        }
        selectedBannerImage = nil
    }
    
    var isFormEmpty: Bool {
        EventEditor.isFormEmpty(title: title, description: description)
    }
    
    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: selectedDate)
    }
    
    var endTimeRange: ClosedRange<Date> {
        Date.endTimeRange(for: selectedDate, startTime: startTime)
    }
}

extension EditEventViewModel {
    var plannerID: Int? {
        return originalEvent.plannerID
    }
}
