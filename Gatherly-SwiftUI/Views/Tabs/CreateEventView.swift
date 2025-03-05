//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct CreateEventView: View {
    @Binding var events: [Event]
    let allUsers: [User]
    
    @State private var eventTitle: String = ""
    @State private var eventDescription: String = ""
    @State private var selectedDate: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600) // just a default for now, 1 hour after startTime
    @State private var selectedMemberIDs: Set<Int> = []
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                eventDetailsSection
                dateTimeSection
                membersSection
                createButtonSection
            }
            .navigationTitle("Create Event")
        }
    }
}

// MARK: - Subviews

private extension CreateEventView {
    var eventDetailsSection: some View {
        Section("Event Details") {
            TextField("Title", text: $eventTitle)
            TextField("Description", text: $eventDescription, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
        }
    }
    
    var dateTimeSection: some View {
        Section("Date & Time") {
            DatePicker("Event Date", selection: $selectedDate, displayedComponents: .date)
            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
        }
    }
    
    var membersSection: some View {
        Section("Invite Friends") {
            ForEach(allUsers, id: \.id) { user in
                Toggle("\(user.firstName ?? "") \(user.lastName ?? "")",
                       isOn: Binding(
                        get: { selectedMemberIDs.contains(user.id ?? -1) },
                        set: { newValue in
                            if newValue {
                                selectedMemberIDs.insert(user.id ?? -1)
                            } else {
                                selectedMemberIDs.remove(user.id ?? -1)
                            }
                        }
                       )
                )
            }
        }
    }
    
    var createButtonSection: some View {
        Section {
            Button(action: createEvent) {
                Text("Create")
                    .font(.headline)
            }
        }
    }
}

// MARK: - Functions

private extension CreateEventView {
    func createEvent() {
        let calendar = Calendar.current
        let mergedStartDate = merge(date: selectedDate, time: startTime)
        let mergedEndDate = merge(date: selectedDate, time: endTime)
        
        let newEvent = Event(
            date: calendar.startOfDay(for: selectedDate),
            description: eventDescription,
            endTimestamp: Int(mergedEndDate.timeIntervalSince1970),
            id: generateEventID(),
            plannerID: 1, //for now, planner is always hard coded to sample user id 1
            memberIDs: Array(selectedMemberIDs),
            title: eventTitle,
            startTimestamp: Int(mergedStartDate.timeIntervalSince1970)
        )
        
        events.append(newEvent)
        clearForm()
    }
    
    func clearForm() {
        eventTitle = ""
        eventDescription = ""
        selectedDate = Date()
        startTime = Date()
        endTime = Date().addingTimeInterval(3600)
        selectedMemberIDs.removeAll()
    }
    
    func merge(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents) ?? Date()
    }
    
    //for now, random ID generation for the event. change later
    func generateEventID() -> Int {
        Int.random(in: 1000...9999)
    }
}

#Preview {
    NavigationStack {
        CreateEventView(
            events: .constant(SampleData.sampleEvents),
            allUsers: SampleData.sampleUsers
        )
    }
}
