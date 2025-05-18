//
//  DayEventsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/15/25.
//

import SwiftUI

struct DayEventsView: View {
    @EnvironmentObject var session: AppSession
    @State private var isShowingCreateEvent = false
    
    let date: Date
    
    var body: some View {
        List {
            if allEventsForDate.isEmpty {
                Text("Nothing planned for this day!")
                    .foregroundColor(.gray)
            } else {
                finishedEventsSection
                inProgressEventsSection
                upcomingEventsSection
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(date.formatted(date: .long, time: .omitted))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingCreateEvent = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(isPresented: $isShowingCreateEvent) {
            CreateEventView(date: date)
        }
    }
}

private extension DayEventsView {
    
    // MARK: - Computed Vars
    
    var allEventsForDate: [Event] {
        session.events
            .filter { event in
                guard let eventDate = event.date else { return false }
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            .sorted(by: { ($0.startTimestamp ?? 0) < ($1.startTimestamp ?? 0) })
    }
    
    var finishedEvents: [Event] {
        allEventsForDate.filter { $0.hasEnded }
    }
    
    var inProgressEvents: [Event] {
        allEventsForDate.filter { $0.isOngoing }
    }
    
    var upcomingEvents: [Event] {
        allEventsForDate.filter { !$0.hasStarted && !$0.hasEnded }
    }
    
    // MARK: - Subviews
    
    var finishedEventsSection: some View {
        Group {
            if !finishedEvents.isEmpty {
                Section(header: Text("Finished")) {
                    ForEach(finishedEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                }
            }
        }
    }
    
    var inProgressEventsSection: some View {
        Group {
            if !inProgressEvents.isEmpty {
                Section(header: Text("In Progress")) {
                    ForEach(inProgressEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                }
            }
        }
    }
    
    var upcomingEventsSection: some View {
        Group {
            if !upcomingEvents.isEmpty {
                Section(header: Text("Upcoming")) {
                    ForEach(upcomingEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                }
            }
        }
    }
}
