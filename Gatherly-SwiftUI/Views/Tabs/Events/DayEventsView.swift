//
//  DayEventsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/15/25.
//

import Combine
import SwiftUI

struct DayEventsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isShowingCreateEvent = false
    @EnvironmentObject var navigationState: NavigationState
    
    private var selectedDate: Date {
        navigationState.calendarSelectedDate ?? Date()
    }
    
    var body: some View {
        List {
            finishedEventsSection
            inProgressEventsSection
            upcomingEventsSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle(selectedDate.formatted(date: .long, time: .omitted))
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
            CreateEventView(date: selectedDate)
        }
        .onChange(of: allEventsForDate) { newValue in
            if newValue.isEmpty {
                dismiss()
            }
        }
    }
}

private extension DayEventsView {
    
    // MARK: - Computed Vars
    
    var allEventsForDate: [Event] {
        eventsViewModel.events
            .filter { event in
                guard let eventDate = event.date else {
                    return false
                }
                
                return Date.isSameDay(date1: eventDate, date2: selectedDate)
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
