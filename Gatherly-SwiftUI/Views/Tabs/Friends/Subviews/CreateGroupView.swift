//
//  CreateGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import Combine
import SwiftUI
import PhotosUI

struct CreateGroupView: View {
    @StateObject private var createGroupViewModel: CreateGroupViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var isSaving = false
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    init(currentUserID: Int) {
        _createGroupViewModel = StateObject(wrappedValue: CreateGroupViewModel(currentUserID: currentUserID))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section(header: Text("Group Name")) {
                        TextField("Enter group name", text: groupNameBinding)
                            .accessibilityIdentifier("groupNameTextField")
                    }
                    
                    ImagePicker(
                        title: "Group Image",
                        imageHeight: Constants.CreateGroupView.groupImageHeight,
                        maskShape: .circle,
                        selectedImage: $createGroupViewModel.groupImage
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $createGroupViewModel.bannerImage
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    createButtonSection
                }
                .navigationTitle("New Group")
                .toolbar {
                    cancelToolbarButton
                }
            }
            if isSaving {
                ActivityIndicator(message: Constants.CreateGroupView.creatingGroupString)
            }
        }
        .keyboardDismissable()
    }
}

private extension CreateGroupView {
    
    // MARK: - Bindings
    
    var groupNameBinding: Binding<String> {
        Binding(
            get: { createGroupViewModel.group.name ?? "" },
            set: { createGroupViewModel.group.name = $0 }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(createGroupViewModel.group.memberIDs) },
            set: { createGroupViewModel.group.memberIDs = Array($0).sorted() }
        )
    }
    
    // MARK: - Subviews
    
    var cancelToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
    }
    
    var createButtonSection: some View {
        Section {
            Button {
                isSaving = true
                
                Task {
                    let newGroup = await createGroupViewModel.preparedGroup()
                    
                    await MainActor.run {
                        groupsViewModel.create(newGroup) { created in
                            navigationState.navigateToGroup = created
                            navigationState.selectedTab = 2
                            isSaving = false
                            dismiss()
                        }
                    }
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(createGroupViewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .accessibilityIdentifier("createGroupButton")
            .disabled(createGroupViewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    CreateGroupView(currentUserID: 1)
}
