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
            VStack(spacing: 0) {
                content
            }
            .navigationTitle("My Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                calendarToolbarButton
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

private extension CalendarView {
    
    // MARK: - Subviews
    
    var calendarToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { isCalendarView.toggle() }) {
                Image(systemName: isCalendarView ? "list.bullet" : "calendar")
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if isCalendarView {
            VStack(spacing: 0) {
                GatherlyCalendarView(
                    selectedDate: $navigationState.calendarSelectedDate,
                    allEvents: $events,
                    currentUser: currentUser,
                    users: users
                )
            }
            .frame(maxHeight: .infinity)
        } else {
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
