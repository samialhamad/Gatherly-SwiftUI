//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @Binding var events: [Event]
    let users: [User]
    
    @StateObject private var viewModel = CalendarViewModel()
    
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        VStack {
            headerView
            calendarView
            eventList
        }
        .padding()
        .onAppear {
            selectedDate = navigationState.calendarSelectedDate
        }
        .onChange(of: selectedDate) { newDate, _ in
            navigationState.calendarSelectedDate = newDate
        }

        .navigationDestination(isPresented: Binding(
            get: { navigationState.navigateToEvent != nil },
            set: { newValue in
                if !newValue {
                    navigationState.navigateToEvent = nil
                }
            }
        )) {
            if let event = navigationState.navigateToEvent {
                EventDetailView(event: event, users: users)
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedDate, format: .dateTime.year().month().day())
                    .font(.title2)
                    .bold()
                Text(viewModel.eventCountLabel(for: selectedDate, events: events))
                    .font(.body)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            if !Date.isSameDay(date1: selectedDate, date2: Date()) {
                Button("Today") {
                    selectedDate = Date()
                }
                .font(.headline)
            }
            
            Image(systemName: "bell.badge")
                .font(.title2)
        }
        .padding()
    }
    
    private var calendarView: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding()
    }
    
    private var eventList: some View {
        List(filteredEvents) { event in
            NavigationLink {
                EventDetailView(
                    event: event,
                    users: users,
                    onSave: { updatedEvent in
                        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                            events[index] = updatedEvent
                        }
                    }
                )
            } label: {
                EventRow(event: event)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: - Computed Vars
    
    private var filteredEvents: [Event] {
        events.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: selectedDate)
        }
    }
}

#Preview {
    CalendarView(events: .constant(SampleData.sampleEvents), users: SampleData.sampleUsers)
}
