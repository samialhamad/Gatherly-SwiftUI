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
        Section("Invite Friends") {
            ForEach(allUsers, id: \.id) { user in
                Toggle("\(user.firstName ?? "") \(user.lastName ?? "")", isOn: Binding(
                    get: { viewModel.selectedMemberIDs.contains(user.id ?? -1) },
                    set: { newValue in
                        if newValue {
                            viewModel.selectedMemberIDs.insert(user.id ?? -1)
                        } else {
                            viewModel.selectedMemberIDs.remove(user.id ?? -1)
                        }
                    }
                ))
            }
        }
    }
    
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
