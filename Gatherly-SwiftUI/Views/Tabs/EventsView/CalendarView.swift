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
    @State private var showCreateEvent = false
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("My Events")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { showCreateEvent.toggle() }) {
                            Image(systemName: "plus")
                        }
                        Button(action: { isCalendarView.toggle() }) {
                            Image(systemName: isCalendarView ? "list.bullet" : "calendar")
                        }
                    }
                }
                .navigationDestination(isPresented: $showCreateEvent) {
                    CreateEventView(allUsers: users, events: $events)
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
            EventsGroupedListView(
                events: $events,
                users: users,
                onEventSave: { updatedEvent in
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
                Button {
                    navigationState.calendarSelectedDate = Date()
                } label: {
                    Image(systemName: "calendar.badge.clock.rtl")
                        .font(.title2)
                        .foregroundColor(Color(Brand.Colors.primary))
                }
            }
        }
        .padding()
    }
    
    var calendarView: some View {
        DatePicker("", selection: $navigationState.calendarSelectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .tint(Color(Brand.Colors.primary))
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
        events.filterEvents(by: navigationState.calendarSelectedDate)
    }
}

#Preview {
    CalendarView(
        events: .constant(SampleData.sampleEvents),
        users: SampleData.sampleUsers
    )
    .environmentObject(NavigationState())
}
