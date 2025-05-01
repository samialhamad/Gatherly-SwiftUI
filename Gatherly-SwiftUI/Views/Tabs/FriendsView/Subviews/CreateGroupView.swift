//
//  CreateGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI
import PhotosUI

struct CreateGroupView: View {
    @ObservedObject var currentUser: User
    @Environment(\.dismiss) private var dismiss
    @Binding var groups: [UserGroup]
    @StateObject private var viewModel = CreateGroupViewModel()
    
    let users: [User]
    
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
                    selectedMemberIDs: $viewModel.selectedMemberIDs,
                    header: "Invite Friends",
                    plannerID: currentUser.id,
                    users: allFriends
                )
                createButtonSection
            }
            .navigationTitle("New Group")
            .toolbar {
                cancelToolbarButton
            }
        }
        .keyboardDismissable()
    }
}

private extension CreateGroupView {
    
    //MARK: - Computed Vars
    
    private var allFriends: [User] {
        guard let friendIDs = currentUser.friendIDs else {
            return []
        }
        
        return users.filter { user in
            friendIDs.contains(user.id ?? -1)
        }
    }
    
    //MARK: - Subviews
    
    var cancelToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
    }
    
    var createButtonSection: some View {
        Section {
            Button(action: {
                let newGroup = viewModel.createGroup(leaderID: currentUser.id ?? 1)
                groups.append(newGroup)
                UserDefaultsManager.saveGroups(groups)
                dismiss()
            }) {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .disabled(viewModel.isFormEmpty)
        }
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        CreateGroupView(
            currentUser: sampleUser,
            groups: .constant(SampleData.sampleGroups),
            users: SampleData.sampleUsers
        )
    }
}
