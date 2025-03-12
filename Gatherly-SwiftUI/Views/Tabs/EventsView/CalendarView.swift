//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct CalendarView: View {
    @Binding var events: [Event]
    let users: [User]
    
    @StateObject private var viewModel = CalendarViewModel()
    @EnvironmentObject var navigationState: NavigationState
    @State private var isCalendarView = true
    
    var body: some View {
        NavigationStack {
            content
                .padding()
                .navigationTitle("My Events")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isCalendarView.toggle() }) {
                            Image(systemName: isCalendarView ? "list.bullet" : "calendar")
                        }
                    }
                }
                .navigationDestination(isPresented: Binding(
                    get: { navigationState.navigateToEvent != nil },
                    set: { newValue in
                        if !newValue { navigationState.navigateToEvent = nil }
                    }
                )) {
                    if let event = navigationState.navigateToEvent {
                        EventDetailView(events: $events, event: event, users: users)
                    } else {
                        EmptyView()
                    }
                }
        }
    }
}

// MARK: - Subviews

private extension CalendarView {
    
    @ViewBuilder
    var content: some View {
        if isCalendarView {
            VStack {
                headerView
                calendarView
                eventListView
            }
        } else {
            let groupedEvents = Dictionary(grouping: events, by: { Date.startOfDay($0.date) })
            
            EventsGroupedListView(
                events: $events,
                users: users,
                groupedEvents: groupedEvents,
                onEventSave: { updatedEvent in
                    // If an event is updated, find & replace it in the array
                    if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                        events[index] = updatedEvent
                    }
                }
            )
        }
    }

    
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(navigationState.calendarSelectedDate, format: .dateTime.year().month().day())
                    .font(.title2)
                    .bold()
                Text(viewModel.eventCountLabel(for: navigationState.calendarSelectedDate, events: events))
                    .font(.body)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            if !Date.isSameDay(date1: navigationState.calendarSelectedDate, date2: Date()) {
                Button("Today") {
                    let today = Date()
                    navigationState.calendarSelectedDate = today
                }
                .font(.headline)
            }
            
            Image(systemName: "bell.badge")
                .font(.title2)
        }
        .padding()
    }
    
    var calendarView: some View {
        DatePicker("", selection: $navigationState.calendarSelectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding()
    }
    
    var eventListView: some View {
        List(filteredEvents) { event in
            EventRowLink(
                events: $events,
                event: event,
                users: users,
                onSave: { updatedEvent in
                    if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                        events[index] = updatedEvent
                    }
                }
            )
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: - Computed Vars
    
    var filteredEvents: [Event] {
        events.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: navigationState.calendarSelectedDate)
        }
    }
    
    var groupedEvents: [Date: [Event]] {
        Dictionary(grouping: events, by: { Date.startOfDay($0.date) })
    }
}

#Preview {
    CalendarView(events: .constant(SampleData.sampleEvents), users: SampleData.sampleUsers)
}
