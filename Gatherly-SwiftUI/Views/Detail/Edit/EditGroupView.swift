//
//  EditGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import SwiftUI

struct EditGroupView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingDeleteAlert = false
    @State private var isSaving = false
    @StateObject var viewModel: EditGroupViewModel
    
    let friendsDict: [Int: User]
    let groups: [UserGroup]
    let onSave: (UserGroup) -> Void
    let onCancel: () -> Void
    let onDelete: (UserGroup) -> Void
    
    private var currentUser: User? {
        session.currentUser
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
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
                            onDelete(viewModel.originalGroup)
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
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    NavigationStack {
        EditGroupView(
            viewModel: EditGroupViewModel(group: SampleData.sampleGroups.first!),
            friendsDict: friendsDict,
            groups: SampleData.sampleGroups,
            onSave: { _ in },
            onCancel: {},
            onDelete: { _ in }
        )
        .environmentObject(AppSession())
    }
}
