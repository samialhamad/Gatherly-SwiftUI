//
//  CreateEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    @StateObject private var createEventViewModel = CreateEventViewModel()
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isSaving = false
    @EnvironmentObject var navigationState: NavigationState
    
    init() {
        _createEventViewModel = StateObject(wrappedValue: CreateEventViewModel())
    }
    
    // Used for automatic date population from DayEventsView
    init(date: Date) {
        let createEventViewModel = CreateEventViewModel()
        createEventViewModel.selectedDate = Date.startOfDay(date)
        _createEventViewModel = StateObject(wrappedValue: createEventViewModel)
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
                        startTimeRange: createEventViewModel.startTimeRange,
                        endTimeRange: createEventViewModel.endTimeRange
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    EventLocationSection(
                        header: "Location",
                        locationName: locationNameBinding,
                        onSetLocation: { location in
                            createEventViewModel.event.location = location
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
                        selectedImage: $createEventViewModel.selectedBannerImage
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
            get: { createEventViewModel.event.categories },
            set: { createEventViewModel.event.categories = $0 }
        )
    }
    
    var descriptionBinding: Binding<String> {
        Binding(
            get: { createEventViewModel.event.description ?? "" },
            set: { createEventViewModel.event.description = $0 }
        )
    }
    
    var endTimeBinding: Binding<Date> {
        Binding(
            get: { createEventViewModel.endTime },
            set: { createEventViewModel.endTime = $0 }
        )
    }
    
    var eventDateBinding: Binding<Date> {
            Binding(
                get: { createEventViewModel.selectedDate },
                set: { newDate in
                    createEventViewModel.selectedDate = newDate
                    let oldStartTime = createEventViewModel.startTime
                    createEventViewModel.startTime = oldStartTime
                    let oldEndTime = createEventViewModel.endTime
                    createEventViewModel.endTime = oldEndTime
                }
            )
        }
    
    var locationNameBinding: Binding<String> {
        Binding(
            get: { createEventViewModel.event.location?.name ?? "" },
            set: { name in
                if createEventViewModel.event.location == nil {
                    createEventViewModel.event.location = Location(
                        address: nil,
                        latitude: 0,
                        longitude: 0,
                        name: name
                    )
                } else {
                    createEventViewModel.event.location?.name = name
                }
            }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(createEventViewModel.event.memberIDs ?? []) },
            set: { createEventViewModel.event.memberIDs = Array($0).sorted() }
        )
    }
    
    var startTimeBinding: Binding<Date> {
        Binding(
            get: { createEventViewModel.startTime },
            set: { createEventViewModel.startTime = $0 }
        )
    }
    
    var titleBinding: Binding<String> {
        Binding(
            get: { createEventViewModel.event.title ?? "" },
            set: { createEventViewModel.event.title = $0 }
        )
    }
    
    // MARK: - Subviews
    
    var createButtonSection: some View {
        Section {
            Button{
                isSaving = true
                let newEvent = createEventViewModel.builtEvent
                
                eventsViewModel.create(newEvent) { createdEvent in
                    createEventViewModel.clearFields()
                    navigationState.pushToEventDetailView(createdEvent)
                    isSaving = false
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(createEventViewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .accessibilityIdentifier("createEventButton")
            .disabled(createEventViewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    CreateEventView()
}
