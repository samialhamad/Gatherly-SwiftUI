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
    
    let friendsDict: [Int: User]
        
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
                        friendsDict: friendsDict)
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
                    friendsDict: friendsDict
                )
            }
            .frame(maxHeight: .infinity)
        } else {
            EventsGroupedListView(
                currentUser: currentUser,
                events: $events,
                friendsDict: friendsDict,
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
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })

    CalendarView(
        currentUser: currentUser,
        events: .constant(SampleData.sampleEvents),
        friendsDict: friendsDict
    )
    .environmentObject(NavigationState())
}
