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
    @Published var endTime: Date = Date().addingTimeInterval(3600)
    @Published var selectedMemberIDs: Set<Int> = []
    
    func mergedStartDate() -> Date {
        DateUtils.merge(date: selectedDate, time: startTime)
    }

    func mergedEndDate() -> Date {
        DateUtils.merge(date: selectedDate, time: endTime)
    }
        
    func createEvent(with plannerID: Int) -> Event {
        let calendar = Calendar.current
        let mergedStart = mergedStartDate()
        let mergedEnd = mergedEndDate()
        
        return Event(
            date: calendar.startOfDay(for: selectedDate),
            description: description,
            endTimestamp: Int(mergedEnd.timeIntervalSince1970),
            id: generateEventID(),
            plannerID: plannerID,
            memberIDs: Array(selectedMemberIDs),
            title: title,
            startTimestamp: Int(mergedStart.timeIntervalSince1970)
        )
    }
    
    private func generateEventID() -> Int {
        Int.random(in: 1000...9999)
    }
    
    func clearFields() {
        title = ""
        description = ""
        selectedDate = Date()
        startTime = Date()
        endTime = Date().addingTimeInterval(3600)
        selectedMemberIDs.removeAll()
    }
}
