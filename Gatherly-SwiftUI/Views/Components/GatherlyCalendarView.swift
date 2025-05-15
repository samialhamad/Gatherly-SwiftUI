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
    @State private var isShowingDayEvents = false
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friendsDict: [Int: User] {
        session.friendsDict
    }
    
    private var eventsForSelectedDate: [Event] {
        allEvents.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: selectedDate)
        }
        .sorted(by: { ($0.startTimestamp ?? 0) < ($1.startTimestamp ?? 0) })
    }
    
    init(selectedDate: Binding<Date>,
         allEvents: Binding<[Event]>,
         session: AppSession)
    {
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
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
            
            dayEventsViewButton
        }
        .background(
            NavigationLink(
                destination: DayEventsView(date: selectedDate),
                isActive: $isShowingDayEvents,
                label: { EmptyView() }
            )
        )
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
    
    private var dayEventsViewButton: some View {
        Group {
            if !eventsForSelectedDate.isEmpty {
                Button(action: {
                    isShowingDayEvents = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("View Events for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(Colors.primary))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }
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
