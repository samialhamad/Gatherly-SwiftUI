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
    @State private var showPastEvents = false
    
    var body: some View {
        NavigationStack {
            content
                .padding()
                .navigationTitle("My Events")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isCalendarView {
                            Button {
                                showPastEvents.toggle()
                            } label: {
                                Image(systemName: showPastEvents ? "arrow.uturn.left.circle.fill" : "arrow.uturn.left.circle")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isCalendarView.toggle() }) {
                            Image(systemName: isCalendarView ? "list.bullet" : "calendar")
                        }
                    }
                }
                .padding()
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
            eventsGroupedView
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
            NavigationLink {
                EventDetailView(
                    events: $events,
                    event: event,
                    users: users,
                    onSave: { updatedEvent in
                        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                            events[index] = updatedEvent
                        }
                    }
                )
            } label: {
                EventRow(event: event)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var eventsGroupedView: some View {
        List {
            ForEach(groupedEvents.keys.sorted(), id: \.self) { date in
                Section(header: Text(date.formatted(date: .long, time: .omitted))) {
                    ForEach(groupedEvents[date] ?? []) { event in
                        NavigationLink {
                            EventDetailView(
                                events: $events,
                                event: event,
                                users: users,
                                onSave: { updatedEvent in
                                    if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                                        events[index] = updatedEvent
                                    }
                                }
                            )
                        } label: {
                            EventRow(event: event)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
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
        let todayStart = Date.startOfDay(Date())
        let activeEvents = events.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return showPastEvents
                ? (Date.startOfDay(eventDate) < todayStart)
                : (Date.startOfDay(eventDate) >= todayStart)
        }
        return Dictionary(grouping: activeEvents, by: { Date.startOfDay($0.date) })
    }

}

#Preview {
    CalendarView(events: .constant(SampleData.sampleEvents), users: SampleData.sampleUsers)
}
