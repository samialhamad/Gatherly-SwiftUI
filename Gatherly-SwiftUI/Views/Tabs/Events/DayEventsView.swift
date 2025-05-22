//
//  DayEventsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/15/25.
//

import Combine
import SwiftUI

struct DayEventsView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var events: [Event] = []
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingCreateEvent = false
    
    let date: Date
    
    var body: some View {
        List {
            finishedEventsSection
            inProgressEventsSection
            upcomingEventsSection
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
                .accessibilityIdentifier("addEventButton")
            }
        }
        .navigationDestination(isPresented: $isShowingCreateEvent) {
            CreateEventView(date: date)
        }
        .onAppear {
            GatherlyAPI.getEvents()
                .receive(on: RunLoop.main)
                .sink { self.events = $0 }
                .store(in: &cancellables)
        }
        .onChange(of: events) { _ in
            if allEventsForDate.isEmpty {
                dismiss()
            }
        }
    }
}

private extension DayEventsView {
    
    // MARK: - Computed Vars
    
    var allEventsForDate: [Event] {
        events
            .filter { event in
                guard let eventDate = event.date else {
                    return false
                }
                
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
                Section {
                    ForEach(finishedEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                } header: {
                    Text("Finished")
                        .accessibilityIdentifier("sectionHeader-Finished")
                }
            }
        }
    }
    
    var inProgressEventsSection: some View {
        Group {
            if !inProgressEvents.isEmpty {
                Section {
                    ForEach(inProgressEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                } header: {
                    Text("In Progress")
                        .accessibilityIdentifier("sectionHeader-In Progress")
                }
            }
        }
    }
    
    
    var upcomingEventsSection: some View {
        Group {
            if !upcomingEvents.isEmpty {
                Section {
                    ForEach(upcomingEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                } header: {
                    Text("Upcoming")
                        .accessibilityIdentifier("sectionHeader-Upcoming")
                }
            }
        }
    }
}
