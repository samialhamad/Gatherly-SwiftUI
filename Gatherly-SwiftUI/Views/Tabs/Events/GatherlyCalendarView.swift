//
//  GatherlyCalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//
import SwiftUI

struct GatherlyCalendarView: View {
    @Binding var allEvents: [Event]
    @State private var isShowingDayEvents = false
    @Binding var selectedDate: Date?
    
    let navigationState: NavigationState

    private var eventsForSelectedDate: [Event] {
        guard let selected = selectedDate else {
            return []
        }
        
        return allEvents.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            return Calendar.current.isDate(eventDate, inSameDayAs: selected)
        }
        .sorted { ($0.startTimestamp ?? 0) < ($1.startTimestamp ?? 0) }
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
        .padding(.horizontal)
        .background(
            NavigationLink(
                destination: DayEventsView(date: selectedDate ?? Date()),
                isActive: $isShowingDayEvents,
                label: { EmptyView() }
            )
        )
        .onChange(of: navigationState.navigateToEventsForDate) { newDate in
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
                    .padding(.top)
                    .padding(.bottom)
            }
        }
    }
    
    private var dayEventsViewButton: some View {
        VStack(spacing: Constants.GatherlyCalendarView.dayEventsViewButtonSpacing) {
            let selected = selectedDate ?? Date()
            
            Text(allEvents.eventCountLabel(for: selected))
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
