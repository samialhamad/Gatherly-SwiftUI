//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct CreateEventView: View {
    // Binding to the shared events array
    @Binding var events: [Event]
    // All users to invite as members
    let allUsers: [User]
    
    // Use a StateObject for the view model
    @StateObject private var viewModel = CreateEventViewModel()
    
    // For this example, we hard-code the current planner's ID (current user)
    let currentPlannerID: Int = 1
    
    var body: some View {
        NavigationStack {
            Form {
                EventDetailsSection(
                    header: "Event Details",
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
                    header: "Invite Friends",
                    allUsers: allUsers,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
                )
                createButtonSection
            }
            .navigationTitle("Create Event")
        }
    }
}

// MARK: - Subviews

private extension CreateEventView {
    var createButtonSection: some View {
        Section {
            Button(action: {
                let newEvent = viewModel.createEvent(with: currentPlannerID)
                events.append(newEvent)
                viewModel.clearFields()
            }) {
                Text("Create")
                    .font(.headline)
            }
        }
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
