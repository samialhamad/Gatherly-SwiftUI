//
//  GatherlyCalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//

import ElegantCalendar
import SwiftUI

struct GatherlyCalendarView: View {
    @EnvironmentObject var session: AppSession
    @Binding var allEvents: [Event]
    @StateObject private var calendarManager: ElegantCalendarManager
    @Binding var selectedDate: Date
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friendsDict: [Int: User] {
        session.friendsDict
    }
    
    init(selectedDate: Binding<Date>, allEvents: Binding<[Event]>) {
        _selectedDate = selectedDate
        _allEvents = allEvents
        
        let manager = ElegantCalendarManager.withEvents(
            selectedDate: selectedDate,
            events: allEvents.wrappedValue
        )
        _calendarManager = StateObject(wrappedValue: manager)
    }
    
    var body: some View {
        VStack(spacing: Constants.GatherlyCalendarView.vstackSpacing) {
            ElegantCalendarView(calendarManager: calendarManager)
                .theme(CalendarTheme(
                    primary: Color(Colors.primary),
                    todayTextColor: .white,
                    todayBackgroundColor: Color(Colors.primary)
                ))
                .padding(.top, Constants.GatherlyCalendarView.topPadding)
        }
        .onReceive(calendarManager.$monthlyManager.map(\.selectedDate)) { newDate in
            if let date = newDate {
                selectedDate = date
            }
        }
        .background(Color.white)
        .onAppear {
            calendarManager.datasource = self
            calendarManager.scrollToDay(selectedDate, animated: true)
        }
    }
}

// MARK: - Calendar Data Source

extension GatherlyCalendarView: ElegantCalendarDataSource {
    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        return GatherlyEventListView(
            allEvents: $allEvents,
            date: date
        )
        .erased
    }
    
    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        allEvents.contains { event in
            Date.isSameDay(date1: event.date ?? .distantPast, date2: date)
        } ? 1.0 : 0.0
    }
    
    func calendar(canSelectDate date: Date) -> Bool {
        true
    }
}

// MARK: - Event List View

struct GatherlyEventListView: View {
    @EnvironmentObject var session: AppSession
    @Binding var allEvents: [Event]
    
    let date: Date
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friendsDict: [Int: User] {
        session.friendsDict
    }
    
    private var filteredEvents: [Event] {
        allEvents.filterEvents(by: date)
    }
    
    var body: some View {
        VStack(spacing: Constants.CalendarView.eventListViewSpacing) {
            if filteredEvents.isEmpty {
                Text("Nothing planned for this day!")
                    .font(.body)
                    .foregroundColor(Color(Colors.primary))
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(filteredEvents) { event in
                    EventRowLink(event: event)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.leading, Constants.GatherlyCalendarView.eventListViewLeadingPadding)
        .padding(.trailing, Constants.GatherlyCalendarView.eventListViewTrailingPadding)
        .padding(.top, Constants.GatherlyCalendarView.eventListViewTopPadding)
    }
}
