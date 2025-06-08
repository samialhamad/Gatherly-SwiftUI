//
//  EventDateTimeSection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventDateTimeSection: View {
    let header: String
    let eventDate: Binding<Date>
    let startTime: Binding<Date>
    let endTime: Binding<Date>
    
    let startTimeRange: ClosedRange<Date>
    let endTimeRange: ClosedRange<Date>
    
    var body: some View {
        Section(header: Text(header)) {
            DatePicker("Event Date", selection: eventDate, in: Date()..., displayedComponents: .date)
                .accessibilityIdentifier("eventDatePicker")
            
            DatePicker("Start Time", selection: startTime, in: startTimeRange, displayedComponents: .hourAndMinute)
                .accessibilityIdentifier("startTimePicker")
            
            DatePicker("End Time", selection: endTime, in: endTimeRange, displayedComponents: .hourAndMinute)
                .accessibilityIdentifier("endTimePicker")
        }
        .tint(Color(Colors.primary))
    }
}
