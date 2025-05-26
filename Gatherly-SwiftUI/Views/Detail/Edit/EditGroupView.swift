//
//  EditGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import SwiftUI

struct EditGroupView: View {
    @StateObject var editGroupViewModel: EditGroupViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var showingDeleteAlert = false
    @State private var isSaving = false
    
    let friendsDict: [Int: User]
    let onSave: (UserGroup) -> Void
    let onCancel: () -> Void
    let onDelete: (UserGroup) -> Void
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section(header: Text("Group Name")) {
                        TextField("Enter group name", text: nameBinding)
                            .accessibilityIdentifier("editGroupNameTextField")
                    }
                    
                    ImagePicker(
                        title: "Group Image",
                        imageHeight: Constants.CreateGroupView.groupImageHeight,
                        maskShape: .circle,
                        selectedImage: $editGroupViewModel.groupImage
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $editGroupViewModel.bannerImage
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Friends"
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
                        isSaving = true
                        Task {
                            onDelete(editGroupViewModel.originalGroup)
                            isSaving = false
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this group?")
                }
            }
            if isSaving {
                ActivityIndicator(message: Constants.EditGroupView.savingChangesString)
            }
        }
        .keyboardDismissable()
    }
}

private extension EditGroupView {
    
    // MARK: - Bindings
    
    var nameBinding: Binding<String> {
        Binding<String>(
            get: { editGroupViewModel.group.name ?? "" },
            set: { editGroupViewModel.group.name = $0 }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding<Set<Int>>(
            get: { Set(editGroupViewModel.group.memberIDs) },
            set: { editGroupViewModel.group.memberIDs = Array($0).sorted() }
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
            .accessibilityIdentifier("deleteGroupButton")
            .foregroundColor(.red)
        }
    }
    
    var saveToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                Task {
                    let updatedGroup = await editGroupViewModel.prepareUpdatedGroup()
                    groupsViewModel.update(updatedGroup)
                    isSaving = false
                    onSave(updatedGroup)
                }
            }
            .accessibilityIdentifier("saveGroupButton")
            .foregroundColor(editGroupViewModel.isFormEmpty ? .gray : Color(Colors.secondary))
            .disabled(editGroupViewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditGroupView(
            editGroupViewModel: EditGroupViewModel(group: SampleData.sampleGroups.first!),
            friendsDict: friendsDict,
            onSave: { _ in },
            onCancel: {},
            onDelete: { _ in }
        )
    }
}
