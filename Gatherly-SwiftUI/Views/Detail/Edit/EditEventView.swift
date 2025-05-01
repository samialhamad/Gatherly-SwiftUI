//
//  EditEventView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import SwiftUI

struct EditEventView: View {
    @StateObject var viewModel: EditEventViewModel
    let allUsers: [User]
    let events: [Event]
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
                    header: "Members",
                    allUsers: friends,
                    plannerID: viewModel.plannerID,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
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
        }
        .keyboardDismissable()
    }
}

private extension EditEventView {
    
    // MARK: - Computed Vars
    
    private var friends: [User] {
        guard let plannerID = viewModel.plannerID else { return [] }
        
        guard let planner = allUsers.first(where: { $0.id == plannerID }),
              let friendIDs = planner.friendIDs else {
            return []
        }

        return allUsers.filter { user in
            if let id = user.id {
                return friendIDs.contains(id)
            }
            return false
        }
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
                let updatedEvent = viewModel.updatedEvent()
                onSave(updatedEvent)
            }
            .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(viewModel.isFormEmpty)
        }
    }
}

#Preview {
    NavigationStack {
        EditEventView(
            viewModel: EditEventViewModel(event: SampleData.sampleEvents.first!),
            allUsers: SampleData.sampleUsers,
            events: SampleData.sampleEvents,
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
