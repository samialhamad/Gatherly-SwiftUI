//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var session: AppSession
    @State private var isSaving = false
    @State private var showingDeleteAlert = false
    @StateObject var viewModel: EditEventViewModel
    
    let events: [Event]
    let friendsDict: [Int: User]
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    let onDelete: (Event) -> Void
    
    private var currentUser: User? {
        session.currentUser
    }
    
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
                        startTimeRange: viewModel.startTimeRange,
                        endTimeRange: viewModel.endTimeRange
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Members"
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
                        imageHeight: Constants.EditEventView.bannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $viewModel.selectedBannerImage
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
                        onDelete(viewModel.originalEvent)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this event?")
                }
            }
            if isSaving {
                ActivityIndicator(message: "Saving your changes!")
            }
        }
        .keyboardDismissable()
    }
}

private extension EditEventView {
    
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
                Date(timeIntervalSince1970: TimeInterval(viewModel.event.endTimestamp ?? Int(Date().addingTimeInterval(3600).timestamp)))
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
            set: { newValue in
                var current = viewModel.event.location ?? Location(address: nil, latitude: 0, longitude: 0)
                current.name = newValue
                viewModel.event.location = current
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
            .foregroundColor(.red)
        }
    }
    
    var saveToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                Task {
                    let updatedEvent = await viewModel.updateEvent()
                    isSaving = false
                    onSave(updatedEvent)
                }
            }
            .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(viewModel.isFormEmpty)
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditEventView(
            viewModel: EditEventViewModel(event: SampleData.sampleEvents.first!),
            events: SampleData.sampleEvents,
            friendsDict: friendsDict,
            onSave: { _ in },
            onCancel: {},
            onDelete: { _ in }
        )
        .environmentObject(AppSession())
    }
}
