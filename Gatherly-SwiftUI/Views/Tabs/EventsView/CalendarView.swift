//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var session: AppSession
    @State private var isCalendarView = true
    @StateObject private var viewModel = CalendarViewModel()
    
    private var currentUser: User? {
        session.currentUser
    }
    
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
                get: { session.navigationState.navigateToEvent != nil },
                set: { newValue in
                    if !newValue { session.navigationState.navigateToEvent = nil }
                }
            )) {
                if let event = session.navigationState.navigateToEvent {
                    EventDetailView(event: event)
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
                    selectedDate: $session.navigationState.calendarSelectedDate,
                    allEvents: $session.events
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
        .environmentObject(AppSession())
}
