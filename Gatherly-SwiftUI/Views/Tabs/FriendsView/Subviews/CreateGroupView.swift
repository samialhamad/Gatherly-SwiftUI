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
    
    let friendsDict: [Int: User]

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
                    currentUser: currentUser,
                    friendsDict: friendsDict
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
    
    private var friends: [User] {
        currentUser.resolvedFriends(from: friendsDict)
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
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })

    CreateGroupView(
        currentUser: currentUser,
        groups: .constant(SampleData.sampleGroups),
        friendsDict: friendsDict
    )
}
