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
    @State private var isShowingDayEvents = false
    
    let navigationState: NavigationState
    
    private var eventsForSelectedDate: [Event] {
        let selected = calendarManager.selectedDate ?? Date()
        
        return allEvents.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: selected)
        }
        .sorted(by: { ($0.startTimestamp ?? 0) < ($1.startTimestamp ?? 0) })
    }
    
    init(
        allEvents: Binding<[Event]>,
        navigationState: NavigationState
    ) {
        _allEvents = allEvents
        self.navigationState = navigationState
        
        let manager = ElegantCalendarManager.withEvents(
            events: allEvents,
            navigationState: navigationState
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
                .accessibilityIdentifier("gatherlyCalendar")
                .padding(.top, Constants.GatherlyCalendarView.topPadding)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
            
            dayEventsViewButton
        }
        .background(
            NavigationLink(
                destination: DayEventsView(date: calendarManager.selectedDate ?? Date()),
                isActive: $isShowingDayEvents,
                label: { EmptyView() }
            )
        )
        .background(Color.white)
        .onAppear {
            calendarManager.datasource = self
            if let selected = calendarManager.selectedDate {
                calendarManager.scrollToDay(selected, animated: true)
            }
        }
        .onChange(of: navigationState.navigateToEventsForDate) { newDate in
            guard let date = newDate else {
                return
            }
            calendarManager.scrollToDay(date, animated: true)
        }
    }
    
    private var dayEventsViewButton: some View {
        VStack(spacing: Constants.GatherlyCalendarView.dayEventsViewButtonSpacing) {
            let selectedDate = calendarManager.selectedDate ?? Date()
            
            Text(allEvents.eventCountLabel(for: selectedDate))
                .font(.headline)
                .foregroundColor(Color(Colors.primary))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if !eventsForSelectedDate.isEmpty {
                Button(action: {
                    isShowingDayEvents = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("View Events for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                            .accessibilityIdentifier("viewEventsForDateButton")
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
