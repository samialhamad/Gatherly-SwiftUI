//
//  CreateGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI
import PhotosUI

struct CreateGroupView: View {
    let currentUser: User
    @StateObject private var viewModel = CreateGroupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Enter group name", text: $viewModel.groupName)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                }
                
                ImagePickerSection(
                    title: "Group Image",
                    imageHeight: Constants.CreateGroupView.groupImageHeight,
                    selectedImage: $viewModel.groupImage
                )
                
                ImagePickerSection(
                    title: "Banner Image",
                    imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                    selectedImage: $viewModel.bannerImage
                )
                
                EventMembersSection(
                    header: "Invite Friends",
                    allUsers: allFriends,
                    plannerID: currentUser.id,
                    selectedMemberIDs: $viewModel.selectedMemberIDs
                )
                createButtonSection
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private extension CreateGroupView {
    
    //MARK: - Computed Vars

    private var allFriends: [User] {
        guard let friendIDs = currentUser.friendIDs else {
            return []
        }
        return SampleData.sampleUsers.filter { user in
            friendIDs.contains(user.id ?? -1)
        }
    }
    
    //MARK: - Subviews

    var createButtonSection: some View {
        Section {
            Button(action: {
                let newGroup = viewModel.createGroup(creatorID: 1)
                groups.append(newGroup)
            }) {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .disabled(viewModel.isFormEmpty)
        }
    }
    
}
