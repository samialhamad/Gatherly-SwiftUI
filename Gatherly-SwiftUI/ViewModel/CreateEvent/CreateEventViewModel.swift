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
    @Published var selectedMemberIDs: Set<Int> = []
    @Published var locationName: String = ""
    @Published var location: Location? = nil
    
    func createEvent(with plannerID: Int) -> Event {
        return EventEditor.saveEvent(
            title: title,
            description: description,
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: selectedMemberIDs,
            plannerID: plannerID,
            location: location
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

