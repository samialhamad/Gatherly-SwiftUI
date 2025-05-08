//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    @State private var isSaving = false
    @StateObject var viewModel: EditEventViewModel
    
    let currentUser: User
    let events: [Event]
    let friendsDict: [Int: User]
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    let onDelete: (Event) -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                EventDetailsSection(
                    header: "Event Info",
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
                    header: "Members",
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
            .overlay {
                if isSaving {
                    ActivityIndicator(message: "Saving your changes…")
                }
            }
        }
        .keyboardDismissable()
    }
}

private extension EditEventView {
    
    // MARK: - Computed Vars
    
    private var friends: [User] {
        currentUser.resolvedFriends(from: friendsDict)
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
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditEventView(
            viewModel: EditEventViewModel(event: SampleData.sampleEvents.first!),
            currentUser: currentUser,
            events: SampleData.sampleEvents,
            friendsDict: friendsDict,
            onSave: { updatedEvent in
                print("Event updated: \(updatedEvent)")
            },
            onCancel: {
                print("Edit cancelled")
            },
            onDelete: { event in
                print("Delete event: \(event)")
            }
        )
    }
}
