//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Combine
import SwiftUI

struct CalendarView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var events: [Event] = []
    @State private var isCalendarView = true
    @State private var isLoading = true
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ActivityIndicator(message: Constants.ContentView.calendarViewLoadingString)
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
                navigationState.hasShownDayEventsView = false
                
                isLoading = true
                GatherlyAPI.getEvents()
                    .receive(on: RunLoop.main)
                    .sink { fetchedEvents in
                        self.events = fetchedEvents
                        self.isLoading = false
                    }
                    .store(in: &cancellables)
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
            VStack(spacing: 0) {
                GatherlyCalendarView(
                    selectedDate: $navigationState.calendarSelectedDate,
                    allEvents: $events,
                    navigationState: navigationState
                )
            }
            .frame(maxHeight: .infinity)
        } else {
            EventsGroupedListView()
        }
    }
}

#Preview {
    CalendarView()
}
