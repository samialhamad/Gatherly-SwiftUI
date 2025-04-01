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
    
    @State private var groupPhoto: PhotosPickerItem?
    @State private var bannerPhoto: PhotosPickerItem?
    
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
                
                Section {
                    Button("Create Group") {
                        createGroup()
                        dismiss()
                    }
                    .disabled(viewModel.groupName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("New Group")
            .onChange(of: groupPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.groupImage = uiImage
                    }
                }
            }
            .onChange(of: bannerPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.bannerImage = uiImage
                    }
                }
            }
        }
    }
    
    //MARK: - Computed Vars
    
    private var allFriends: [User] {
        guard let friendIDs = currentUser.friendIDs else {
            return []
        }
        return SampleData.sampleUsers.filter { user in
            friendIDs.contains(user.id ?? -1)
        }
    }
    
    //place holder
    private func createGroup() {
        print("✅ Group Created: \(viewModel.groupName)")
        print("Members: \(viewModel.selectedMemberIDs)")
    }
}
