//
//  GatherlyCalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//
import SwiftUI

struct GatherlyCalendarView: View {
    @Binding var allEvents: [Event]
    @StateObject private var gatherlyCalendarViewModel = GatherlyCalendarViewModel()
    @State private var isShowingDayEvents = false
    @Binding var selectedDate: Date?
    
    let navigationState: NavigationState

    private var eventsForSelectedDate: [Event] {
        guard let selectedDate else {
            return []
        }
        
        return allEvents.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: selectedDate)
        }
    }
    
    var body: some View {
        VStack(spacing: Constants.GatherlyCalendarView.vstackSpacing) {
            calendarMonthHeader
            
            SwiftUICalendarView(
                selectedDate: $selectedDate,
                events: allEvents,
                navigationState: navigationState
            )
            .frame(height: Constants.GatherlyCalendarView.calendarViewFrameHeight)
            .accessibilityIdentifier("gatherlyCalendar")
            .padding(.top, Constants.GatherlyCalendarView.topPadding)
            
            Spacer()
            
            dayEventsViewButton
                .frame(height: Constants.GatherlyCalendarView.dayEventsViewButtonFrameHeight)
        }
        .refreshOnAppear()
        .padding(.horizontal)
        .navigationDestination(isPresented: $isShowingDayEvents) {
            DayEventsView()
        }
        .onChange(of: navigationState.navigateToEventsForDate) { _, newDate in
            guard let date = newDate else {
                return
            }
            selectedDate = date
        }
    }
    
    // MARK: - Subviews
    
    private var calendarMonthHeader: some View {
        Group {
            if let selectedDate {
                Text(selectedDate.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .accessibilityIdentifier("calendarMonthHeader")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                    .padding(.vertical)
                    .padding(.horizontal, Constants.GatherlyCalendarView.calendarMonthHeaderHorziontalPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var dayEventsViewButton: some View {
        VStack(spacing: Constants.GatherlyCalendarView.dayEventsViewButtonSpacing) {
            let selected = selectedDate ?? Date()
            
            Text(gatherlyCalendarViewModel.eventCountLabel(for: selected, events: allEvents))
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if !eventsForSelectedDate.isEmpty {
                Button(action: {
                    isShowingDayEvents = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("View Events for \(selected.formatted(date: .abbreviated, time: .omitted))")
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
