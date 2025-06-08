//
//  EventFormView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import SwiftUI
import PhotosUI

struct EventFormView: View {
    @StateObject private var eventFormViewModel: EventFormViewModel
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isSaving = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var showingDeleteAlert = false
    
    private let onSave: ((Event) -> Void)?
    private let onCancel: (() -> Void)?
    private let onDelete: ((Event) -> Void)?
    
    // create mode init
    init() {
        let eventFormViewModel = EventFormViewModel(mode: .create, event: nil)
        _eventFormViewModel = StateObject(wrappedValue: eventFormViewModel)
        onSave = nil
        onCancel = nil
        onDelete = nil
    }
    
    // create mode init with date passed from DayEventsView
    
    init(date: Date) {
        let eventFormViewModel = EventFormViewModel(mode: .create, event: nil)
        eventFormViewModel.selectedDate = Date.startOfDay(date)
        _eventFormViewModel = StateObject(wrappedValue: eventFormViewModel)
        onSave = nil
        onCancel = nil
        onDelete = nil
    }
    
    // edit mode init
    init(
        event: Event,
        onSave: @escaping (Event) -> Void,
        onCancel: @escaping () -> Void,
        onDelete: @escaping (Event) -> Void
    ) {
        let eventFormViewModel = EventFormViewModel(mode: .edit(event: event))
        _eventFormViewModel = StateObject(wrappedValue: eventFormViewModel)
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete
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
                        startTimeRange: eventFormViewModel.startTimeRange,
                        endTimeRange: eventFormViewModel.endTimeRange
                    )
                    
                    FriendsSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    EventLocationSection(
                        header: "Location",
                        locationName: locationNameBinding
                    ) { location in
                        eventFormViewModel.event.location = location
                    }
                    
                    EventCategorySection(
                        header: "Categories",
                        selectedCategories: categoriesBinding
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: eventFormViewModel.mode == .create
                        ? Constants.EventFormView.bannerImageHeight
                        : Constants.EventFormView.bannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $eventFormViewModel.selectedBannerImage
                    )
                    
                    if eventFormViewModel.mode == .create {
                        createButtonSection
                    } else {
                        deleteButtonSection
                    }
                }
                .navigationTitle(eventFormViewModel.mode == .create ? "Create Event" : "Edit Event")
                .toolbar {
                    if case .edit(_) = eventFormViewModel.mode {
                        cancelToolbarButton
                        saveToolbarButton
                    }
                }
                .alert("Delete Event?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        onDelete?(eventFormViewModel.event)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this event?")
                }
            }
            
            if isSaving {
                ActivityIndicator(
                    message: eventFormViewModel.mode == .create
                    ? Constants.EventFormView.creatingEventString
                    : Constants.EventFormView.savingChangesString
                )
            }
        }
        .keyboardDismissable()
    }
    
    // MARK: — Bindings
    
    private var titleBinding: Binding<String> {
        Binding(
            get: { eventFormViewModel.event.title ?? "" },
            set: { eventFormViewModel.event.title = $0 }
        )
    }
    
    private var descriptionBinding: Binding<String> {
        Binding(
            get: { eventFormViewModel.event.description ?? "" },
            set: { eventFormViewModel.event.description = $0 }
        )
    }
    
    private var eventDateBinding: Binding<Date> {
        Binding(
            get: { eventFormViewModel.selectedDate },
            set: { newDate in
                eventFormViewModel.selectedDate = newDate
                eventFormViewModel.startTime = eventFormViewModel.startTime
                eventFormViewModel.endTime = eventFormViewModel.endTime
            }
        )
    }
    
    private var startTimeBinding: Binding<Date> {
        Binding(
            get: { eventFormViewModel.startTime },
            set: { eventFormViewModel.startTime = $0 }
        )
    }
    
    private var endTimeBinding: Binding<Date> {
        Binding(
            get: { eventFormViewModel.endTime },
            set: { eventFormViewModel.endTime = $0 }
        )
    }
    
    private var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(eventFormViewModel.event.memberIDs ?? []) },
            set: { newSet in
                eventFormViewModel.event.memberIDs = Array(newSet).sorted()
            }
        )
    }
    
    private var locationNameBinding: Binding<String> {
        Binding(
            get: { eventFormViewModel.event.location?.name ?? "" },
            set: { newName in
                if eventFormViewModel.event.location == nil {
                    eventFormViewModel.event.location = Location(
                        address: nil,
                        latitude: 0,
                        longitude: 0,
                        name: newName
                    )
                } else {
                    eventFormViewModel.event.location?.name = newName
                }
            }
        )
    }
    
    private var categoriesBinding: Binding<[EventCategory]> {
        Binding(
            get: { eventFormViewModel.event.categories },
            set: { eventFormViewModel.event.categories = $0 }
        )
    }
    
    // MARK: — Subviews & Buttons
    
    private var createButtonSection: some View {
        Section {
            Button {
                isSaving = true
                let newEvent = eventFormViewModel.builtEvent
                eventsViewModel.create(newEvent) { createdEvent in
                    eventFormViewModel.clearFields()
                    navigationState.pushToEventDetailView(createdEvent)
                    isSaving = false
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(
                        eventFormViewModel.isFormEmpty ? .gray : Color(Colors.primary)
                    )
            }
            .accessibilityIdentifier("createEventButton")
            .disabled(eventFormViewModel.isFormEmpty || isSaving)
        }
    }
    
    private var deleteButtonSection: some View {
        Section {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .accessibilityIdentifier("deleteEventButton")
            .foregroundColor(.red)
        }
    }
    
    private var cancelToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                onCancel?()
            }
        }
    }
    
    private var saveToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                Task {
                    let updated = await eventFormViewModel.prepareUpdatedEvent()
                    eventsViewModel.update(updated)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSaving = false
                        onSave?(updated)
                    }
                }
            }
            .accessibilityIdentifier("saveEventButton")
            .foregroundColor(
                eventFormViewModel.isFormEmpty
                ? .gray
                : Color(Colors.secondary)
            )
            .disabled(eventFormViewModel.isFormEmpty)
        }
    }
}
