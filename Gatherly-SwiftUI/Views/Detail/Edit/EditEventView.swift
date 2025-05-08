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
                    title: Binding(
                        get: { viewModel.event.title ?? "" },
                        set: { viewModel.event.title = $0 }
                    ),
                    description: Binding(
                        get: { viewModel.event.description ?? "" },
                        set: { viewModel.event.description = $0 }
                    )
                )
                
                EventDateTimeSection(
                    header: "Date & Time",
                    eventDate: Binding(
                        get: { viewModel.event.date ?? Date() },
                        set: { viewModel.event.date = $0 }
                    ),
                    startTime: Binding(
                        get: {
                            Date(timeIntervalSince1970: TimeInterval(viewModel.event.startTimestamp ?? Int(Date().timestamp)))
                        },
                        set: {
                            viewModel.event.startTimestamp = Int($0.timestamp)
                        }
                    ),
                    endTime: Binding(
                        get: {
                            Date(timeIntervalSince1970: TimeInterval(viewModel.event.endTimestamp ?? Int(Date().addingTimeInterval(3600).timestamp)))
                        },
                        set: {
                            viewModel.event.endTimestamp = Int($0.timestamp)
                        }
                    ),
                    startTimeRange: viewModel.startTimeRange,
                    endTimeRange: viewModel.endTimeRange
                )
                
                EventMembersSection(
                    selectedMemberIDs: Binding(
                        get: { Set(viewModel.event.memberIDs ?? []) },
                        set: { viewModel.event.memberIDs = Array($0).sorted() }
                    ),
                    header: "Members",
                    currentUser: currentUser,
                    friendsDict: friendsDict
                )
                
                EventLocationSection(
                    header: "Location",
                    locationName: Binding(
                        get: { viewModel.event.location?.name ?? "" },
                        set: { newValue in
                            var current = viewModel.event.location ?? Location(
                                address: nil,
                                latitude: 0,
                                longitude: 0
                            )
                            current.name = newValue
                            viewModel.event.location = current
                        }
                    ),
                    onSetLocation: { location in
                        viewModel.event.location = location
                    }
                )
                
                EventCategorySection(
                    header: "Categories",
                    selectedCategories: Binding(
                        get: { viewModel.event.categories },
                        set: { viewModel.event.categories = $0 }
                    )
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
