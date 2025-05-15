//
//  DayEventsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/15/25.
//

import SwiftUI

struct DayEventsView: View {
    @EnvironmentObject var session: AppSession
    
    let date: Date
    
    var body: some View {
        List {
            if eventsForDate.isEmpty {
                Text("Nothing planned for this day!")
                    .foregroundColor(.gray)
            } else {
                ForEach(eventsForDate) { event in
                    EventRowLink(event: event, showDisclosure: false)
                }
            }
        }
        .navigationTitle(date.formatted(date: .long, time: .omitted))
    }
}

private extension DayEventsView {
    // MARK: - Computed Vars
    
    private var eventsForDate: [Event] {
        session.events
            .filter { event in
                guard let eventDate = event.date else {
                    return false
                }
                
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
        
            .sorted(by: { ($0.startTimestamp ?? 0) < ($1.startTimestamp ?? 0) })
    }
}
