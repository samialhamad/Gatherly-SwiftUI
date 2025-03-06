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
        
        if let eventDate = event.date {
            self.selectedDate = eventDate
        } else {
            self.selectedDate = Date()
        }
        
        if let startTimestamp = event.startTimestamp {
            self.startTime = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
        } else {
            self.startTime = Date()
        }
        
        if let endTimestamp = event.endTimestamp {
            self.endTime = Date(timeIntervalSince1970: TimeInterval(endTimestamp))
        } else {
            self.endTime = Date().addingTimeInterval(3600)
        }
        
        self.selectedMemberIDs = Set(event.memberIDs ?? [])
    }
    
    func mergedStartDate() -> Date {
        DateUtils.merge(date: selectedDate, time: startTime)
    }
    
    func mergedEndDate() -> Date {
        DateUtils.merge(date: selectedDate, time: endTime)
    }
    
    func updatedEvent() -> Event {
        var updatedEvent = originalEvent
        updatedEvent.title = title
        updatedEvent.description = description
        updatedEvent.startTimestamp = Int(mergedStartDate().timeIntervalSince1970)
        updatedEvent.endTimestamp = Int(mergedEndDate().timeIntervalSince1970)
        updatedEvent.date = Calendar.current.startOfDay(for: selectedDate)
        updatedEvent.memberIDs = Array(selectedMemberIDs)
        
        return updatedEvent
    }
}
