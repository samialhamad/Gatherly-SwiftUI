//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    let event: Event
    let allUsers: [User]
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    
    @State private var title: String
    @State private var description: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var selectedMemberIDs: Set<Int>
    
    init(
        event: Event,
        allUsers: [User],
        onSave: @escaping (Event) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.event = event
        self.allUsers = allUsers
        self.onSave = onSave
        self.onCancel = onCancel
        
        _title = State(initialValue: event.title ?? "")
        _description = State(initialValue: event.description ?? "")
        
        let now = Date()
        
        let startTime: Date = {
            guard let startTimestamp = event.startTimestamp else {
                return now
            }
            return Date(timeIntervalSince1970: TimeInterval(startTimestamp))
        }()
        
        let endTime: Date = {
            guard let endTimestamp = event.endTimestamp else {
                return now.addingTimeInterval(3600)
            }
            return Date(timeIntervalSince1970: TimeInterval(endTimestamp))
        }()
        
        _startDate = State(initialValue: startTime)
        _endDate = State(initialValue: endTime)
        
        _selectedMemberIDs = State(initialValue: Set(event.memberIDs ?? []))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                generalInfoSection
                dateTimeSection
                membersSection
            }
            .navigationTitle("Edit Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var generalInfoSection: some View {
        Section("General Info") {
            TextField("Title", text: $title)
            TextField("Description", text: $description, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
        }
    }
    
    private var dateTimeSection: some View {
        Section("Date & Time") {
            DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
        }
    }
    
    private var membersSection: some View {
        Section("Members") {
            // Toggle each user in allUsers
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
    
    // MARK: - Save Event
    
    private func saveEvent() {
        var updatedEvent = event
        
        updatedEvent.title = title
        updatedEvent.description = description
        updatedEvent.startTimestamp = Int(startDate.timeIntervalSince1970)
        updatedEvent.endTimestamp = Int(endDate.timeIntervalSince1970)
        updatedEvent.date = Calendar.current.startOfDay(for: startDate)
        updatedEvent.memberIDs = Array(selectedMemberIDs)
        
        onSave(updatedEvent)
    }
}
