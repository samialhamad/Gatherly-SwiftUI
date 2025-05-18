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
    @StateObject private var viewModel = CalendarViewModel()
    
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
        .background(Color.white)
        .onReceive(calendarManager.$monthlyManager.map(\.selectedDate)) { newDate in
            if let date = newDate {
                selectedDate = date
            }
        }
        .onAppear {
            calendarManager.datasource = self
            calendarManager.scrollToDay(selectedDate, animated: true)
        }
        .navigationDestination(isPresented: $isShowingDayEvents) {
            DayEventsView(date: selectedDate)
        }
    }
    
    private var dayEventsViewButton: some View {
        VStack(spacing: Constants.GatherlyCalendarView.dayEventsViewButtonSpacing) {
            Text(viewModel.eventCountLabel(for: selectedDate, events: allEvents))
                .font(.headline)
                .foregroundColor(Color(Colors.primary))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

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
                .background(Color(Colors.primary))
                .cornerRadius(Constants.GatherlyCalendarView.dayEventsViewButtonCornerRadius)
                .padding(.horizontal)
            }
            .padding(.bottom, Constants.GatherlyCalendarView.dayEventsViewButtonBottomPadding)
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
