//
//  GatherlyCalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//

import ElegantCalendar
import SwiftUI

struct GatherlyCalendarView: View {
    @Binding var allEvents: [Event]
    @StateObject private var calendarManager: ElegantCalendarManager
    @Binding var selectedDate: Date
    
    let currentUser: User
    let users: [User]

    init(selectedDate: Binding<Date>,
         allEvents: Binding<[Event]>,
         currentUser: User,
         users: [User]) {

        _selectedDate = selectedDate
        _allEvents = allEvents
        self.currentUser = currentUser
        self.users = users

        let config = CalendarConfiguration(
            startDate: Date().addingTimeInterval(-60*60*24*365),
            endDate: Date().addingTimeInterval(60*60*24*365)
        )

        let manager = ElegantCalendarManager(configuration: config, initialMonth: selectedDate.wrappedValue)
        _calendarManager = StateObject(wrappedValue: manager)
    }

    var body: some View {
        VStack(spacing: 0) {
            ElegantCalendarView(calendarManager: calendarManager)
                .theme(CalendarTheme(
                    primary: Color(Colors.primary),
                    todayTextColor: .white,
                    todayBackgroundColor: Color(Colors.primary)
                ))
                .padding(.top, 76)
        }
        .onReceive(calendarManager.$monthlyManager.map(\.selectedDate)) { newDate in
            if let date = newDate {
                selectedDate = date
            }
        }
        .background(Color.white)
        .onAppear {
            calendarManager.datasource = self
            calendarManager.delegate = self
        }
    }
}

// MARK: - Calendar Data Source

extension GatherlyCalendarView: ElegantCalendarDataSource {
    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        return GatherlyEventListView(
            date: date,
            currentUser: currentUser,
            users: users,
            allEvents: $allEvents
        )
        .erased
    }

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        allEvents.contains(where: { Calendar.current.isDate($0.date ?? .distantPast, inSameDayAs: date) }) ? 1.0 : 0.0
    }

    func calendar(canSelectDate date: Date) -> Bool {
        true
    }
}

extension GatherlyCalendarView: ElegantCalendarDelegate {
    func calendar(didSelectDay date: Date) {
        selectedDate = date
    }
}

// MARK: - Event List View

struct GatherlyEventListView: View {
    let date: Date
    let currentUser: User
    let users: [User]
    @Binding var allEvents: [Event]

    var filteredEvents: [Event] {
        allEvents.filterEvents(by: date)
    }

    var body: some View {
        VStack(spacing: Constants.CalendarView.eventListViewSpacing) {
            if filteredEvents.isEmpty {
                Text("Nothing planned for this day!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(filteredEvents) { event in
                    EventRowLink(
                        currentUser: currentUser,
                        events: $allEvents,
                        event: event,
                        users: users,
                        onSave: { updatedEvent in
                            if let index = allEvents.firstIndex(where: { $0.id == updatedEvent.id }) {
                                allEvents[index] = updatedEvent
                            }
                        },
                        showDisclosure: true
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.leading, -12)
        .padding(.trailing, 16)
        .padding(.top, 8)
    }
}
