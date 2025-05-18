//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    @EnvironmentObject var session: AppSession
    @State private var isSaving = false
    @StateObject private var viewModel = CreateEventViewModel()
    
    private var currentUser: User? {
        session.currentUser
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: CreateEventViewModel())
    }

    // Used for automatic date population from CalendarView
    init(date: Date) {
        let viewModel = CreateEventViewModel()
        viewModel.event.date = date
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
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
                        header: "Invite Friends"
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
                .navigationTitle("Create Event")
            }
            if isSaving {
                ActivityIndicator(message: Constants.CreateEventView.creatingEventString)
            }
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
    
    // MARK: - Subviews
    
    var createButtonSection: some View {
        Section {
            Button(action: { [weak session] in
                isSaving = true
                guard let plannerID = currentUser?.id else {
                    return
                }
                
                Task {
                    let newEvent = await viewModel.createEvent(plannerID: plannerID)
                    
                    await MainActor.run {
                        guard let session else {
                            return
                        }
                        
                        session.events.append(newEvent)
                        viewModel.clearFields()
                        session.navigationState.calendarSelectedDate = newEvent.date ?? Date()
                        session.navigationState.navigateToEvent = newEvent
                        session.navigationState.selectedTab = 0
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
    CreateEventView()
        .environmentObject(AppSession())
}
