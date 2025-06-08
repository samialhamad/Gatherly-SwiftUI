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
            onGoingEventsSection
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
            EventFormView(date: selectedDate)
        }
        .navigationDestination(isPresented: Binding(
            get: { navigationState.navigateToEvent != nil },
            set: { newValue in
                if !newValue { navigationState.navigateToEvent = nil }
            }
        )) {
            if let event = navigationState.navigateToEvent {
                EventDetailView(event: event)
            } else {
                EmptyView()
            }
        }
        .onChange(of: allEventsForDate) { _, newValue in
            if newValue.isEmpty {
                dismiss()
            }
        }
    }
}

private extension DayEventsView {
    
    // MARK: - Computed Vars
    
    var allEventsForDate: [Event] {
        DayEventsViewModel.allEvents(for: eventsViewModel.events, on: selectedDate)
    }
    
    var finishedEvents: [Event] {
        DayEventsViewModel.finishedEvents(for: eventsViewModel.events, on: selectedDate)
    }
    
    var onGoingEvents: [Event] {
        DayEventsViewModel.onGoingEvents(for: eventsViewModel.events, on: selectedDate)
    }
    
    var upcomingEvents: [Event] {
        DayEventsViewModel.upcomingEvents(for: eventsViewModel.events, on: selectedDate)
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
    
    var onGoingEventsSection: some View {
        Group {
            if !onGoingEvents.isEmpty {
                Section {
                    ForEach(onGoingEvents) { event in
                        EventRowLink(event: event, showDisclosure: false)
                    }
                } header: {
                    Text("Happening now")
                        .accessibilityIdentifier("sectionHeader-Happening Now")
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
