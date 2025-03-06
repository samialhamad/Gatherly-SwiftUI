//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    @StateObject var viewModel: EditEventViewModel
    let allUsers: [User]
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                eventInfoSection
                dateTimeSection
                membersSection
                saveButtonSection
            }
            .navigationTitle("Edit Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

private extension EditEventView {
    var eventInfoSection: some View {
        Section("Event Info") {
            TextField("Title", text: $viewModel.title)
            TextField("Description", text: $viewModel.description, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
        }
    }
    
    var dateTimeSection: some View {
        Section("Date & Time") {
            DatePicker("Event Date", selection: $viewModel.selectedDate, displayedComponents: .date)
            DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
        }
    }
    
    var membersSection: some View {
        Section("Members") {
            ForEach(allUsers, id: \.id) { user in
                Toggle("\(user.firstName ?? "") \(user.lastName ?? "")",
                       isOn: Binding(
                        get: { viewModel.selectedMemberIDs.contains(user.id ?? -1) },
                        set: { newValue in
                            if newValue {
                                viewModel.selectedMemberIDs.insert(user.id ?? -1)
                            } else {
                                viewModel.selectedMemberIDs.remove(user.id ?? -1)
                            }
                        }
                       )
                )
            }
        }
    }
    
    var saveButtonSection: some View {
        Section {
            Button("Save") {
                let updatedEvent = viewModel.updatedEvent()
                onSave(updatedEvent)
            }
        }
    }
}

