//
//  EventDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Combine
import MapKit
import SwiftUI

struct EventDetailView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @Environment(\.dismiss) var dismiss
    @StateObject private var eventDetailViewModel = EventDetailViewModel()
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var friendsDict: [Int: User] = [:]
    @State private var isShowingEditView = false
    @State private var isLoading = true
    @EnvironmentObject var navigationState: NavigationState
    @State private var showMapOptions = false
    @State private var updatedEvent: Event
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    init(event: Event) {
        _updatedEvent = State(initialValue: event)
    }
    
    var body: some View {
        Group {
            if isLoading {
                ActivityIndicator(message: Constants.EventDetailView.loadingString)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        eventBannerImageView
                        
                        VStack(alignment: .leading, spacing: Constants.EventDetailView.bodyVStackSpacing) {
                            eventDateView
                            eventTimeView
                            eventDescriptionView
                            eventMapPreview
                            eventPlannerAndMembersView
                            eventCategoriesView
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .navigationTitle(updatedEvent.title ?? "Untitled Event")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        editButton
                    }
                    .toolbarRole(.editor)
                    .sheet(isPresented: $isShowingEditView) {
                        editEventSheet
                    }
                    .deletionFailedAlert(for: $eventsViewModel.deletionFailed, message: "Failed to delete event")
                }
            }
        }
        .refreshOnAppear()
        .onAppear {
            GatherlyAPI.getUsers()
                .receive(on: RunLoop.main)
                .sink { users in
                    self.friendsDict = Dictionary(uniqueKeysWithValues: users.compactMap { user in
                        guard let id = user.id else {
                            return nil
                        }
                        
                        return (id, user)
                    })
                    self.isLoading = false
                }
                .store(in: &cancellables)
        }
    }
}

private extension EventDetailView {
    
    // MARK: - Computed Vars
    
    private var planner: User? {
        guard let currentUser = usersViewModel.currentUser,
              let plannerID = updatedEvent.plannerID else {
            return nil
        }
        
        return plannerID == currentUser.id ? currentUser : friendsDict[plannerID]
    }
    
    private var members: [User] {
        guard let memberIDs = updatedEvent.memberIDs else {
            return []
        }
        
        return memberIDs
            .filter { $0 != updatedEvent.plannerID }
            .compactMap { id in
                id == usersViewModel.currentUser?.id ? usersViewModel.currentUser : friendsDict[id]
            }
    }
    
    // MARK: - Subviews
    
    var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if updatedEvent.plannerID == usersViewModel.currentUser?.id {
                Button("Edit") {
                    isShowingEditView = true
                }
                .disabled(updatedEvent.hasStarted || updatedEvent.hasEnded)
            }
        }
    }
    
    var editEventSheet: some View {
        EditEventView(
            editEventViewModel: EditEventViewModel(event: updatedEvent),
            friendsDict: friendsDict,
            onSave: { savedEvent in
                self.updatedEvent = savedEvent
                eventsViewModel.update(savedEvent)
                navigationState.calendarSelectedDate = savedEvent.date
                isShowingEditView = false
            },
            onCancel: {
                isShowingEditView = false
            },
            onDelete: { eventToDelete in
                eventsViewModel.delete(eventToDelete)
                isShowingEditView = false
                dismiss()
            }
        )
        .refreshOnDismiss()
    }
    
    var eventBannerImageView: some View {
        let image: UIImage? = {
            guard let imageName = updatedEvent.bannerImageName else {
                return nil
            }
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }()
        
        return BannerView(
            cornerRadius: 0,
            bottomPadding: 0,
            height: Constants.AvatarHeaderView.rectangleFrameHeight,
            image: image
        )
    }
    
    var eventCategoriesView: some View {
        Group {
            if !updatedEvent.categories.isEmpty {
                HStack(alignment: .center, spacing: Constants.EventDetailView.eventCategoriesViewSpacing) {
                    Text("Categories:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    ForEach(updatedEvent.categories, id: \.self) { category in
                        category.icon
                    }
                }
            }
        }
    }
    
    var eventDateView: some View {
        Group {
            if let date = updatedEvent.date {
                Text("Date: \(date.formatted(date: .long, time: .omitted))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventDescriptionView: some View {
        Group {
            if let description = updatedEvent.description {
                Text(description)
                    .font(.body)
            }
        }
    }
    
    var eventMapPreview: some View {
        Group {
            if let location = updatedEvent.location {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                let annotation = LocationAnnotation(coordinate: coordinate, name: location.name)
                
                Map(coordinateRegion: .constant(region), annotationItems: [annotation]) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack(spacing: Constants.EventDetailView.eventMapPreviewVStackSpacing) {
                            if let name = location.name, !name.isEmpty {
                                Text(name)
                                    .font(.caption)
                                    .padding(Constants.EventDetailView.eventMapPreviewTextPadding)
                                    .background(Color.white)
                                    .cornerRadius(Constants.EventDetailView.eventMapPreviewCornerRadius)
                                    .shadow(radius: Constants.EventDetailView.eventMapPreviewShadow)
                            }
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: Constants.EventDetailView.eventMapPreviewFrame)
                .cornerRadius(Constants.EventDetailView.eventMapPreviewCornerRadius)
                
                if let address = location.address {
                    Button(action: {
                        showMapOptions = true
                    }) {
                        Text(address)
                            .foregroundColor(Color(Colors.primary))
                            .padding(.horizontal, Constants.EventDetailView.eventMapPreviewButtonPadding)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .actionSheet(isPresented: $showMapOptions) {
                        ActionSheet(
                            title: Text("Open in Maps"),
                            buttons: eventDetailViewModel.mapOptions(for: location)
                        )
                    }
                }
            }
        }
    }
    
    var eventPlannerAndMembersView: some View {
        Group {
            if let planner {
                Text("Planner")
                    .font(.headline)
                NavigationLink(destination: UserDetailView(user: planner)) {
                    ProfileRow(user: planner)
                }
            }
            if !members.isEmpty {
                Text("Attendees")
                    .font(.headline)
                ForEach(members, id: \.id) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        ProfileRow(user: user)
                    }
                }
            }
        }
        .foregroundColor(.primary)
    }
    
    var eventTimeView: some View {
        Group {
            if let startTimestamp = updatedEvent.startTimestamp,
               let endTimestamp = updatedEvent.endTimestamp {
                let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
                let endDate = Date(timeIntervalSince1970: TimeInterval(endTimestamp))
                
                Text("Time: \(startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    let sampleEvent = SampleData.sampleEvents[1]
    EventDetailView(event: sampleEvent)
}
