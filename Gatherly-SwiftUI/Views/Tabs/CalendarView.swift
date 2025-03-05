//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    let events: [Event]
    let users: [User]
    
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
    
    private var headerView: some View {
        HStack {
            Text(selectedDate, format: .dateTime.year().month().day())
                .font(.title2)
                .bold()
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
            NavigationLink(destination: EventDetailView(event: event, users: users)) {
                EventRow(event: event)
            }
        }
        .listStyle(PlainListStyle())
    }
    
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
    CalendarView(events: SampleData.sampleEvents, users: SampleData.sampleUsers)
}
