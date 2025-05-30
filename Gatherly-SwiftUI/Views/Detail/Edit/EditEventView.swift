//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    @StateObject var editEventViewModel: EditEventViewModel
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @State private var isSaving = false
    @State private var showingDeleteAlert = false
    
    let friendsDict: [Int: User]
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    let onDelete: (Event) -> Void
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    EventDetailsSection(
                        header: "Event Info",
                        title: titleBinding,
                        description: descriptionBinding
                    )
                    
                    EventDateTimeSection(
                        header: "Date & Time",
                        eventDate: eventDateBinding,
                        startTime: startTimeBinding,
                        endTime: endTimeBinding,
                        startTimeRange: editEventViewModel.startTimeRange,
                        endTimeRange: editEventViewModel.endTimeRange
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Members"
                    )
                    
                    EventLocationSection(
                        header: "Location",
                        locationName: locationNameBinding,
                        onSetLocation: { location in
                            editEventViewModel.event.location = location
                        }
                    )
                    
                    EventCategorySection(
                        header: "Categories",
                        selectedCategories: categoriesBinding
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: Constants.EditEventView.bannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $editEventViewModel.selectedBannerImage
                    )
                    
                    deleteButton
                }
                .navigationTitle("Edit Event")
                .toolbar {
                    cancelToolbarButton
                    saveToolbarButton
                }
                .alert("Delete Event?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        onDelete(editEventViewModel.originalEvent)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this event?")
                }
            }
            if isSaving {
                ActivityIndicator(message: Constants.EditEventView.savingChangesString)
            }
        }
        .keyboardDismissable()
    }
}

private extension EditEventView {
    
    // MARK: - Bindings
    
    var categoriesBinding: Binding<[EventCategory]> {
        Binding(
            get: { editEventViewModel.event.categories },
            set: { editEventViewModel.event.categories = $0 }
        )
    }
    
    var descriptionBinding: Binding<String> {
        Binding(
            get: { editEventViewModel.event.description ?? "" },
            set: { editEventViewModel.event.description = $0 }
        )
    }
    
    var endTimeBinding: Binding<Date> {
        Binding(
            get: {
                Date(timeIntervalSince1970: TimeInterval(editEventViewModel.event.endTimestamp ?? Int(Date().addingTimeInterval(3600).timestamp)))
            },
            set: {
                editEventViewModel.event.endTimestamp = Int($0.timestamp)
            }
        )
    }
    
    var eventDateBinding: Binding<Date> {
        Binding(
            get: { editEventViewModel.event.date ?? Date() },
            set: { editEventViewModel.event.date = $0 }
        )
    }
    
    var locationNameBinding: Binding<String> {
        Binding(
            get: { editEventViewModel.event.location?.name ?? "" },
            set: { newValue in
                var current = editEventViewModel.event.location ?? Location(address: nil, latitude: 0, longitude: 0)
                current.name = newValue
                editEventViewModel.event.location = current
            }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(editEventViewModel.event.memberIDs ?? []) },
            set: { editEventViewModel.event.memberIDs = Array($0).sorted() }
        )
    }
    
    var startTimeBinding: Binding<Date> {
        Binding(
            get: {
                Date(timeIntervalSince1970: TimeInterval(editEventViewModel.event.startTimestamp ?? Int(Date().timestamp)))
            },
            set: {
                editEventViewModel.event.startTimestamp = Int($0.timestamp)
            }
        )
    }
    
    var titleBinding: Binding<String> {
        Binding(
            get: { editEventViewModel.event.title ?? "" },
            set: { editEventViewModel.event.title = $0 }
        )
    }
    
    // MARK: - Subviews
    
    var cancelToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                onCancel()
            }
        }
    }
    
    var deleteButton: some View {
        Section {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .accessibilityIdentifier("deleteEventButton")
            .foregroundColor(.red)
        }
    }
    
    var saveToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                Task {
                    let updatedEvent = await editEventViewModel.prepareUpdatedEvent()
                    eventsViewModel.update(updatedEvent)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSaving = false
                        onSave(updatedEvent)
                    }
                }
            }
            .accessibilityIdentifier("saveEventButton")
            .foregroundColor(editEventViewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(editEventViewModel.isFormEmpty)
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditEventView(
            editEventViewModel: EditEventViewModel(event: SampleData.sampleEvents.first!),
            friendsDict: friendsDict,
            onSave: { _ in },
            onCancel: {},
            onDelete: { _ in }
        )
    }
}
