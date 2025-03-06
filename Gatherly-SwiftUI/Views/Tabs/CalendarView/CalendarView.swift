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
    
    var body: some View {
        VStack {
            headerView
            calendarView
            eventList
        }
        .padding()
        .navigationDestination(for: Event.self) { event in
            EventDetailView(event: event, users: users)
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
            
            return Calendar.current.isDate(eventDate, inSameDayAs: selectedDate)
        }
    }
}

#Preview {
    CalendarView(events: .constant(SampleData.sampleEvents), users: SampleData.sampleUsers)
}
