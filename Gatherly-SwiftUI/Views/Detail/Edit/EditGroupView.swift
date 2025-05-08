//
//  EditGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import SwiftUI

struct EditGroupView: View {
    @State private var showingDeleteAlert = false
    @State private var isSaving = false
    @StateObject var viewModel: EditGroupViewModel
    
    let currentUser: User
    let friendsDict: [Int: User]
    let groups: [UserGroup]
    let onSave: (UserGroup) -> Void
    let onCancel: () -> Void
    let onDelete: (UserGroup) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Group Name")) {
                        TextField("Enter group name", text: nameBinding)
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
                        selectedMemberIDs: memberIDsBinding,
                        header: "Friends",
                        currentUser: currentUser,
                        friendsDict: friendsDict
                    )
                    
                    deleteButton
                }
                
                if isSaving {
                    ActivityIndicator(message: "Saving your changes…")
                }
            }
            .navigationTitle("Edit Group")
            .toolbar {
                cancelToolbarButton
                saveToolbarButton
            }
            .alert("Delete Group?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    isSaving = true
                    Task {
                        await onDelete(viewModel.originalGroup)
                        isSaving = false
                    }
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
    
    // MARK: - Bindings
    
    var nameBinding: Binding<String> {
        Binding<String>(
            get: { viewModel.group.name ?? "" },
            set: { viewModel.group.name = $0 }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding<Set<Int>>(
            get: { Set(viewModel.group.memberIDs) },
            set: { viewModel.group.memberIDs = Array($0).sorted() }
        )
    }
    
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
                    let updatedGroup = await viewModel.updateGroup()
                    isSaving = false
                    onSave(updatedGroup)
                }
            }
            .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(viewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditGroupView(
            viewModel: EditGroupViewModel(group: SampleData.sampleGroups.first!),
            currentUser: currentUser,
            friendsDict: friendsDict,
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
