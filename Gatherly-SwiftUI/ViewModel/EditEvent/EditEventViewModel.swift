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
    }
    
    func updatedEvent() -> Event {
        return EventEditor.saveEvent(
            originalEvent: originalEvent,
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs,
            plannerID: originalEvent.plannerID ?? 0,
            location: location
        )
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
