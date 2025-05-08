//
//  EditEventViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation
import SwiftUI

class EditEventViewModel: ObservableObject {
    @Published var description: String
    @Published var endTime: Date
    @Published var location: Location?
    @Published var locationName: String
    @Published var selectedBannerImage: UIImage?
    @Published var selectedCategories: [EventCategory]
    @Published var selectedDate: Date
    @Published var selectedMemberIDs: Set<Int>
    @Published var startTime: Date
    @Published var title: String

    private let original: Event

    var originalEvent: Event {
        original
    }

    init(event: Event) {
        self.original = event

        self.title = event.title ?? ""
        self.description = event.description ?? ""
        self.selectedDate = event.date ?? Date()
        self.startTime = event.startTimestamp.map { Date(timeIntervalSince1970: TimeInterval($0)) } ?? Date()
        self.endTime = event.endTimestamp.map { Date(timeIntervalSince1970: TimeInterval($0)) }
            ?? Date().plus(calendarComponent: .hour, value: 1) ?? Date()
        self.selectedMemberIDs = Set(event.memberIDs ?? [])
        self.location = event.location
        self.locationName = event.location?.name ?? ""
        self.selectedCategories = event.categories

        if let imageName = event.bannerImageName {
            self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: imageName)
        }
    }

    // MARK: - Update Logic

    func updateEvent() async -> Event {
        var bannerImageName: String? = original.bannerImageName

        if let newImage = selectedBannerImage {
            bannerImageName = ImageUtility.saveImageToDocuments(image: newImage)
        }

        return await GatherlyAPI.updateEvent(
            original,
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs,
            location: location,
            categories: selectedCategories,
            bannerImageName: bannerImageName
        )
    }

    // MARK: - Helpers

    func removeBannerImage() {
        if let imageName = original.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: imageName)
        }
        selectedBannerImage = nil
    }

    var isFormEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var startTimeRange: ClosedRange<Date> {
        Date.startTimeRange(for: selectedDate)
    }

    var endTimeRange: ClosedRange<Date> {
        Date.endTimeRange(for: selectedDate, startTime: startTime)
    }

    var plannerID: Int? {
        original.plannerID
    }
}
