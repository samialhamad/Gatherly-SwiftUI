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
    
    init(selectedDate: Binding<Date>, allEvents: Binding<[Event]>, session: AppSession) {
        _selectedDate = selectedDate
        _allEvents = allEvents
        
        let manager = ElegantCalendarManager.withEvents(
            selectedDate: selectedDate,
            events: allEvents.wrappedValue,
            session: session
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
        return EmptyView().erased
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
