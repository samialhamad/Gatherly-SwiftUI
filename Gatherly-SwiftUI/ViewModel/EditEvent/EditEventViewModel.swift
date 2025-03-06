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
    
    private let originalEvent: Event
    
    init(event: Event) {
        self.originalEvent = event
        
        self.title = event.title ?? ""
        self.description = event.description ?? ""
        self.selectedDate = event.date ?? Date()
        self.startTime = event.startTimestamp != nil ? Date(timeIntervalSince1970: TimeInterval(event.startTimestamp!)) : Date()
        self.endTime = event.endTimestamp != nil ? Date(timeIntervalSince1970: TimeInterval(event.endTimestamp!)) : Date().addingTimeInterval(3600)
        self.selectedMemberIDs = Set(event.memberIDs ?? [])
    }
    
    func updatedEvent() -> Event {
        return EventEditor.updateEvent(
            original: originalEvent,
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs
        )
    }
    
    var startTimeRange: ClosedRange<Date> {
        DateUtils.startTimeRange(for: selectedDate)
    }
    
    var endTimeRange: ClosedRange<Date> {
        DateUtils.endTimeRange(for: selectedDate, startTime: startTime)
    }
}

