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
                EventDetailsSection(
                    header: "Event Info",
                    title: $viewModel.title,
                    description: $viewModel.description)
                EventDateTimeSection(
                    header: "Date & Time",
                    eventDate: $viewModel.selectedDate,
                    startTime: $viewModel.startTime,
                    endTime: $viewModel.endTime,
                    startTimeRange: viewModel.startTimeRange,
                    endTimeRange: viewModel.endTimeRange
                )
                EventMembersSection(
                    header: "Members",
                    allUsers: allUsers,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
                )
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
    var saveButtonSection: some View {
        Section {
            Button("Save") {
                let updatedEvent = viewModel.updatedEvent()
                onSave(updatedEvent)
            }
        }
    }
}

