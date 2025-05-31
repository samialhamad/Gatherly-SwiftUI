//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Combine
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isCalendarView = true
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        NavigationStack {
            Group {
                if eventsViewModel.isLoading {
                    ActivityIndicator(message: Constants.CalendarView.loadingString)
                } else {
                    VStack(spacing: 0) {
                        content
                    }
                }
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
                    EventDetailView(event: event)
                } else {
                    EmptyView()
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { navigationState.navigateToEventsForDate != nil },
                set: { newValue in
                    if !newValue { navigationState.navigateToEventsForDate = nil }
                }
            )) {
                if let date = navigationState.navigateToEventsForDate {
                    DayEventsView(date: date)
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                eventsViewModel.loadIfNeeded()
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
            .accessibilityIdentifier("toggleCalendarViewButton")
        }
    }
    
    @ViewBuilder
    var content: some View {
        if isCalendarView {
            GatherlyCalendarView(
                allEvents: $eventsViewModel.events,
                navigationState: navigationState
            )
            .frame(maxHeight: .infinity)
        } else {
            EventsGroupedListView()
        }
    }
}

#Preview {
    CalendarView()
}
