//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    @ObservedObject var currentUser: User
    @Binding var events: [Event]
    @State private var navigateToEvent: Event? = nil
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var viewModel = CreateEventViewModel()
    
    let allUsers: [User]
    
    var currentPlannerID: Int {
        currentUser.id ?? -1
    }
    
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
                    selectedMemberIDs: $viewModel.selectedMemberIDs,
                    header: "Invite Friends",
                    plannerID: currentPlannerID,
                    users: friends
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


private extension CreateEventView {
    
    // MARK: - Computed Vars
    
    private var friends: [User] {
        guard let friendIDs = currentUser.friendIDs else { return [] }
        return allUsers.filter { user in
            if let id = user.id {
                return friendIDs.contains(id)
            }
            return false
        }
    }
    
    // MARK: - Subviews

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
    if let sampleUser = SampleData.sampleUsers.first {
        NavigationStack {
            CreateEventView(
                currentUser: sampleUser,
                events: .constant(SampleData.sampleEvents),
                allUsers: SampleData.sampleUsers
            )
            .environmentObject(NavigationState())
        }
    }
}
