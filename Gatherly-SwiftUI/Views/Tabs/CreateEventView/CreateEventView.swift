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
                        title: titleBinding,
                        description: descriptionBinding
                    )
                    
                    EventDateTimeSection(
                        header: "Date & Time",
                        eventDate: eventDateBinding,
                        startTime: startTimeBinding,
                        endTime: endTimeBinding,
                        startTimeRange: viewModel.startTimeRange,
                        endTimeRange: viewModel.endTimeRange
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends",
                        currentUser: currentUser,
                        friendsDict: friendsDict
                    )
                    
                    EventLocationSection(
                        header: "Location",
                        locationName: locationNameBinding,
                        onSetLocation: { location in
                            viewModel.event.location = location
                        }
                    )
                    
                    EventCategorySection(
                        header: "Categories",
                        selectedCategories: categoriesBinding
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
    
    // MARK: - Bindings
    
    var categoriesBinding: Binding<[EventCategory]> {
        Binding(
            get: { viewModel.event.categories },
            set: { viewModel.event.categories = $0 }
        )
    }
    
    var descriptionBinding: Binding<String> {
        Binding(
            get: { viewModel.event.description ?? "" },
            set: { viewModel.event.description = $0 }
        )
    }
    
    var endTimeBinding: Binding<Date> {
        Binding(
            get: {
                Date(timeIntervalSince1970: TimeInterval(viewModel.event.endTimestamp ?? Int(Date().timestamp + 3600)))
            },
            set: {
                viewModel.event.endTimestamp = Int($0.timestamp)
            }
        )
    }
    
    var eventDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.event.date ?? Date() },
            set: { viewModel.event.date = $0 }
        )
    }
    
    var locationNameBinding: Binding<String> {
        Binding(
            get: { viewModel.event.location?.name ?? "" },
            set: { name in
                if viewModel.event.location == nil {
                    viewModel.event.location = Location(
                        address: nil,
                        latitude: 0,
                        longitude: 0,
                        name: name
                    )
                } else {
                    viewModel.event.location?.name = name
                }
            }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(viewModel.event.memberIDs ?? []) },
            set: { viewModel.event.memberIDs = Array($0).sorted() }
        )
    }
    
    var startTimeBinding: Binding<Date> {
        Binding(
            get: {
                Date(timeIntervalSince1970: TimeInterval(viewModel.event.startTimestamp ?? Int(Date().timestamp)))
            },
            set: {
                viewModel.event.startTimestamp = Int($0.timestamp)
            }
        )
    }
    
    var titleBinding: Binding<String> {
        Binding(
            get: { viewModel.event.title ?? "" },
            set: { viewModel.event.title = $0 }
        )
    }
    
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
                    let newEvent = await viewModel.createEvent(plannerID: currentUser.id ?? -1)
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
