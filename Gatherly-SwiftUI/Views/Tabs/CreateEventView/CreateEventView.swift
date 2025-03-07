//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct CreateEventView: View {
    let allUsers: [User]
    let currentPlannerID: Int = 1
    
    @StateObject private var viewModel = CreateEventViewModel()
    @Binding var events: [Event]
    @State private var navigateToEvent: Event? = nil
    
    @EnvironmentObject var navigationState: NavigationState
    
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
                    selectedMemberIDs: $viewModel.selectedMemberIDs,
                    plannerID: currentPlannerID
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
                navigationState.calendarSelectedDate = newEvent.date ?? Date()
                navigationState.navigateToEvent = newEvent
                navigationState.selectedTab = 0
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
            allUsers: SampleData.sampleUsers,
            events: .constant(SampleData.sampleEvents)
        )
    }
}
