//
//  EventFormView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import SwiftUI
import PhotosUI

struct EventFormView: View {
    @StateObject private var eventFormFiewModel: EventFormViewModel
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isSaving = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var showingDeleteAlert = false
    
    // For edit mode
    private let onSave: ((Event) -> Void)?
    private let onCancel: (() -> Void)?
    private let onDelete: ((Event) -> Void)?
    
    // create mode init
    init() {
        let eventFormFiewModel = EventFormViewModel(mode: .create, event: nil)
        _eventFormFiewModel = StateObject(wrappedValue: eventFormFiewModel)
        onSave = nil
        onCancel = nil
        onDelete = nil
    }
    
    // create mode init with date passed from DayEventsView
    
    init(date: Date) {
        let eventFormFiewModel = EventFormViewModel(mode: .create, event: nil)
        eventFormFiewModel.selectedDate = Date.startOfDay(date)
        _eventFormFiewModel = StateObject(wrappedValue: eventFormFiewModel)
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
        let eventFormFiewModel = EventFormViewModel(mode: .edit, event: event)
        _eventFormFiewModel = StateObject(wrappedValue: eventFormFiewModel)
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
                        startTimeRange: eventFormFiewModel.startTimeRange,
                        endTimeRange: eventFormFiewModel.endTimeRange
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    EventLocationSection(
                        header: "Location",
                        locationName: locationNameBinding
                    ) { location in
                        eventFormFiewModel.event.location = location
                    }
                    
                    EventCategorySection(
                        header: "Categories",
                        selectedCategories: categoriesBinding
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: eventFormFiewModel.mode == .create
                        ? Constants.EventFormView.bannerImageHeight
                        : Constants.EventFormView.bannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $eventFormFiewModel.selectedBannerImage
                    )
                    
                    if eventFormFiewModel.mode == .create {
                        createButtonSection
                    } else {
                        deleteButtonSection
                    }
                }
                .navigationTitle(eventFormFiewModel.mode == .create ? "Create Event" : "Edit Event")
                .toolbar {
                    if eventFormFiewModel.mode == .edit {
                        cancelToolbarButton
                        saveToolbarButton
                    }
                }
                .alert("Delete Event?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let original = eventFormFiewModel.originalEvent {
                            onDelete?(original)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this event?")
                }
            }
            
            if isSaving {
                ActivityIndicator(
                    message: eventFormFiewModel.mode == .create
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
            get: { eventFormFiewModel.event.title ?? "" },
            set: { eventFormFiewModel.event.title = $0 }
        )
    }
    
    private var descriptionBinding: Binding<String> {
        Binding(
            get: { eventFormFiewModel.event.description ?? "" },
            set: { eventFormFiewModel.event.description = $0 }
        )
    }
    
    private var eventDateBinding: Binding<Date> {
        Binding(
            get: { eventFormFiewModel.selectedDate },
            set: { newDate in
                eventFormFiewModel.selectedDate = newDate
                eventFormFiewModel.startTime = eventFormFiewModel.startTime
                eventFormFiewModel.endTime = eventFormFiewModel.endTime
            }
        )
    }
    
    private var startTimeBinding: Binding<Date> {
        Binding(
            get: { eventFormFiewModel.startTime },
            set: { eventFormFiewModel.startTime = $0 }
        )
    }
    
    private var endTimeBinding: Binding<Date> {
        Binding(
            get: { eventFormFiewModel.endTime },
            set: { eventFormFiewModel.endTime = $0 }
        )
    }
    
    private var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(eventFormFiewModel.event.memberIDs ?? []) },
            set: { newSet in
                eventFormFiewModel.event.memberIDs = Array(newSet).sorted()
            }
        )
    }
    
    private var locationNameBinding: Binding<String> {
        Binding(
            get: { eventFormFiewModel.event.location?.name ?? "" },
            set: { newName in
                if eventFormFiewModel.event.location == nil {
                    eventFormFiewModel.event.location = Location(
                        address: nil,
                        latitude: 0,
                        longitude: 0,
                        name: newName
                    )
                } else {
                    eventFormFiewModel.event.location?.name = newName
                }
            }
        )
    }
    
    private var categoriesBinding: Binding<[EventCategory]> {
        Binding(
            get: { eventFormFiewModel.event.categories },
            set: { eventFormFiewModel.event.categories = $0 }
        )
    }
    
    // MARK: — Subviews & Buttons
    
    private var createButtonSection: some View {
        Section {
            Button {
                isSaving = true
                let newEvent = eventFormFiewModel.builtEvent
                eventsViewModel.create(newEvent) { createdEvent in
                    eventFormFiewModel.clearFields()
                    navigationState.pushToEventDetailView(createdEvent)
                    isSaving = false
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(
                        eventFormFiewModel.isFormEmpty ? .gray : Color(Colors.primary)
                    )
            }
            .accessibilityIdentifier("createEventButton")
            .disabled(eventFormFiewModel.isFormEmpty || isSaving)
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
                    let updated = await eventFormFiewModel.prepareUpdatedEvent()
                    eventsViewModel.update(updated)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSaving = false
                        onSave?(updated)
                    }
                }
            }
            .accessibilityIdentifier("saveEventButton")
            .foregroundColor(
                eventFormFiewModel.isFormEmpty
                ? .gray
                : Color(Colors.secondary)
            )
            .disabled(eventFormFiewModel.isFormEmpty)
        }
    }
}
