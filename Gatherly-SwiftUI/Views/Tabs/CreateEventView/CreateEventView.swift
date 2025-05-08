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
    @State private var isSaving = false
    @State private var navigateToEvent: Event? = nil
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var viewModel = CreateEventViewModel()
    
    let friendsDict: [Int: User]
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        currentUser: currentUser,
                        friendsDict: friendsDict
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
                if isSaving {
                    ActivityIndicator(message: "Creating your event…")
                }
            }
            .navigationTitle("Create Event")
        }
        .keyboardDismissable()
    }
}


private extension CreateEventView {
    
    // MARK: - Computed Vars
    
    private var friends: [User] {
        currentUser.resolvedFriends(from: friendsDict)
    }
    
    // MARK: - Subviews
    
    var createButtonSection: some View {
        Section {
            Button(action: {
                isSaving = true
                Task {
                    let newEvent = await viewModel.createEvent(with: currentUser.id ?? -1)
                    await MainActor.run {
                        events.append(newEvent)
                        viewModel.clearFields()
                        navigationState.calendarSelectedDate = newEvent.date ?? Date()
                        navigationState.navigateToEvent = newEvent
                        navigationState.selectedTab = 0
                        isSaving = false
                    }
                }
            }) {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .disabled(viewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        CreateEventView(
            currentUser: currentUser,
            events: .constant(SampleData.sampleEvents),
            friendsDict: friendsDict
        )
        .environmentObject(NavigationState())
    }
}
