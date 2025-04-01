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
                    allUsers: allUsers,
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
                ImagePickerSection(
                    title: "Banner Image",
                    imageHeight: Constants.EditEventView.bannerImageHeight,
                    selectedImage: $viewModel.selectedBannerImage
                )
                saveAndDeleteSection
            }
            .navigationTitle("Edit Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
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
    }
}

// MARK: - Subviews

private extension EditEventView {
    var saveAndDeleteSection: some View {
        Section {
            Button("Save") {
                let updatedEvent = viewModel.updatedEvent()
                onSave(updatedEvent)
            }
            .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            .disabled(viewModel.isFormEmpty)
            
            Button("Delete") {
                showingDeleteAlert = true
            }
            .foregroundColor(.red)
        }
    }
}

#Preview {
    NavigationStack {
        EditEventView(
            viewModel: EditEventViewModel(event: SampleData.sampleEvents.first!),
            allUsers: SampleData.sampleUsers,
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
