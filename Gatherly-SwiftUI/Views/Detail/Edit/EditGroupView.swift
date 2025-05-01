//
//  EditGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import SwiftUI

struct EditGroupView: View {
    @StateObject var viewModel: EditGroupViewModel
    let allUsers: [User]
    let currentUser: User
    let groups: [UserGroup]
    let onSave: (UserGroup) -> Void
    let onCancel: () -> Void
    let onDelete: (UserGroup) -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Enter group name", text: $viewModel.groupName)
                }
                ImagePicker(
                    title: "Group Image",
                    imageHeight: Constants.CreateGroupView.groupImageHeight,
                    maskShape: .circle,
                    selectedImage: $viewModel.groupImage
                )
                ImagePicker(
                    title: "Banner Image",
                    imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                    maskShape: .rectangle,
                    selectedImage: $viewModel.bannerImage
                )
                EventMembersSection(
                    header: "Friends",
                    allUsers: allUsers,
                    plannerID: viewModel.leaderID,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
                )
                deleteButton
            }
            .navigationTitle("Edit Group")
            .toolbar {
                cancelToolbarButton
                saveToolbarButton
            }
            .alert("Delete Group?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    onDelete(viewModel.originalGroup)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this group?")
            }
        }
        .keyboardDismissable()
    }
}


private extension EditGroupView {
    
    //MARK: - Computed vars
    
    private var allFriends: [User] {
        guard let friendIDs = currentUser.friendIDs else {
            return []
        }
        return SampleData.sampleUsers.filter { user in
            friendIDs.contains(user.id ?? -1)
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
                let updatedGroup = viewModel.updatedGroup()
                onSave(updatedGroup)
            }
            .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(viewModel.isFormEmpty)
        }
    }
}

#Preview {
    NavigationStack {
        EditGroupView(
            viewModel: EditGroupViewModel(group: SampleData.sampleGroups.first!),
            allUsers: SampleData.sampleUsers,
            currentUser: SampleData.sampleUsers.first!,
            groups: SampleData.sampleGroups,
            onSave: { updatedGroup in
                print("Group updated: \(updatedGroup)")
            },
            onCancel: {
                print("Edit cancelled")
            },
            onDelete: { group in
                print("Delete group: \(group)")
            }
        )
    }
}
