//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var currentUser: User
    @Binding var events: [Event]
    @State private var isCalendarView = true
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var viewModel = CalendarViewModel()
    
    let users: [User]
    
    var body: some View {
        NavigationStack {
            content
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
                        EventDetailView(
                            currentUser: currentUser,
                            events: $events,
                            event: event,
                            users: users)
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
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.CalendarView.zeroSpacing) {
                    headerView
                    calendarView
                    eventListView
                }
            }
        }   else {
            EventsGroupedListView(
                currentUser: currentUser,
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
            VStack(alignment: .leading, spacing: Constants.CalendarView.headerViewSpacing) {
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
                        .foregroundColor(Color(Colors.primary))
                }
            }
        }
        .padding()
    }
    
    var calendarView: some View {
        DatePicker("", selection: $navigationState.calendarSelectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .tint(Color(Colors.primary))
            .padding()
    }
    
    var eventListView: some View {
        VStack {
            if !filteredEvents.isEmpty {
                VStack(spacing: Constants.CalendarView.eventListViewSpacing) {
                    ForEach(filteredEvents) { event in
                        EventRowLink(
                            currentUser: currentUser,
                            events: $events,
                            event: event,
                            users: users,
                            onSave: { updatedEvent in
                                if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                                    events[index] = updatedEvent
                                }
                            },
                            showDisclosure: true
                        )
                        .padding(.horizontal)
                    }
                }
            } else {
                Text("Nothing planned for this day!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    // MARK: - Computed Vars
    
    var filteredEvents: [Event] {
        events.filterEvents(by: navigationState.calendarSelectedDate)
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        CalendarView(
            currentUser: sampleUser,
            events: .constant(SampleData.sampleEvents),
            users: SampleData.sampleUsers
        )
        .environmentObject(NavigationState())
    }
}
