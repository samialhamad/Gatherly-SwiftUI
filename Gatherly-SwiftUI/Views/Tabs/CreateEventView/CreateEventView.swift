//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI
import PhotosUI

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
                    plannerID: currentPlannerID,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
                )
                EventLocationSection(
                    header: "Location",
                    locationName: $viewModel.locationName,
                    onSetLocation: { location in
                        viewModel.location = location
                    }
                )
                EventCategorySection(
                    header: "Categories",
                    selectedCategories: $viewModel.selectedCategories
                )
                ImagePicker(
                    title: "Banner Image",
                    imageHeight: Constants.CreateEventView.bannerImageHeight,
                    maskShape: .rectangle,
                    selectedImage: $viewModel.selectedBannerImage
                )
                createButtonSection
            }
            .navigationTitle("Create Event")
        }
        .keyboardDismissable()
    }
}

// MARK: - Subviews

private extension CreateEventView {
    var createButtonSection: some View {
        Section {
            Button(action: {
                let newEvent = viewModel.createEvent(with: currentPlannerID)
                events.append(newEvent)
                UserDefaultsManager.saveEvents(events)
                viewModel.clearFields()
                navigationState.calendarSelectedDate = newEvent.date ?? Date()
                navigationState.navigateToEvent = newEvent
                navigationState.selectedTab = 0
            }) {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .disabled(viewModel.isFormEmpty)
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
