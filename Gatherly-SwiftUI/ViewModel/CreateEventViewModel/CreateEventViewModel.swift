//
//  CreateEventViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation
import SwiftUI

class CreateEventViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedDate: Date = Date()
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date().plus(calendarComponent: .hour, value: 1) ?? Date()
    @Published var selectedCategories: [EventCategory] = []
    @Published var selectedMemberIDs: Set<Int> = []
    @Published var locationName: String = ""
    @Published var location: Location? = nil
    @Published var selectedBannerImage: UIImage?
    
    func createEvent(with plannerID: Int) -> Event {
        var bannerImageName: String? = nil
        if let image = selectedBannerImage {
            bannerImageName = ImageUtility.saveImageToDocuments(image: image)
        }
        
        return EventEditor.saveEvent(
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs,
            plannerID: plannerID,
            location: location,
            categories: selectedCategories,
            bannerImageName: bannerImageName
        )
    }
    
    func clearFields() {
        title = ""
        description = ""
        selectedDate = Date()
        startTime = Date()
        endTime = Date().plus(calendarComponent: .hour, value: 1) ?? Date()
        selectedMemberIDs.removeAll()
        location = nil
        selectedCategories = []
        selectedBannerImage = nil
    }
    
    var isFormEmpty: Bool {
        EventEditor.isFormEmpty(title: title)
    }
    
    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: selectedDate)
    }
    
    var endTimeRange: ClosedRange<Date> {
        Date.endTimeRange(for: selectedDate, startTime: startTime)
    }
}

