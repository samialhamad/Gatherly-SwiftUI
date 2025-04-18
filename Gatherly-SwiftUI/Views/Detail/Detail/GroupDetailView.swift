//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import SwiftUI

struct GroupDetailView: View {
    let group: UserGroup
    let currentUser: User
    let users: [User]
    
    @Binding var groups: [UserGroup]
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.GroupDetailView.vstackSpacing) {
                AvatarHeaderView(
                    group: group,
                    profileImage: profileImage,
                    bannerImage: bannerImage
                )
                
                groupLeaderAndMembersView
                
                Spacer()
            }
        }
        .navigationTitle(group.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarButton
            }
        }
        .confirmationDialog("Options", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
            Button("Leave Group", role: .destructive) {
                leaveGroup()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $isShowingEditView) {
            EditGroupView(
                viewModel: EditGroupViewModel(group: group),
                allUsers: SampleData.sampleUsers, // or real user list if available
                currentUser: currentUser,
                onSave: { updatedGroup in
                    if let index = groups.firstIndex(where: { $0.id == updatedGroup.id }) {
                        groups[index] = updatedGroup
                        UserDefaultsManager.saveGroups(groups)
                    }
                    isShowingEditView = false
                },
                onCancel: {
                    isShowingEditView = false
                },
                onDelete: { deletedGroup in
                    groups = GroupEditor.deleteGroup(from: groups, groupToDelete: deletedGroup)
                    UserDefaultsManager.saveGroups(groups)
                    isShowingEditView = false
                    dismiss()
                }
            )
        }
    }
}

private extension GroupDetailView {
    
    // MARK: - Subviews
    
    var groupLeaderAndMembersView: some View {
        Group {
            if let leader = users.first(where: { $0.id == group.leaderID }) {
                Text("Leader")
                    .font(.headline)
                
                NavigationLink(destination: ProfileDetailView(user: leader, currentUser: currentUser)) {
                    ProfileRow(user: leader)
                }
            }
            
            if !memberUsers.isEmpty {
                Text("Members")
                    .font(.headline)
                
                ForEach(memberUsers, id: \.id) { user in
                    NavigationLink(destination: ProfileDetailView(user: user, currentUser: currentUser)) {
                        ProfileRow(user: user)
                    }
                }
            }
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var toolbarButton: some View {
        if isLeader {
            return AnyView(
                Button("Edit") {
                    isShowingEditView = true
                }
            )
        } else {
            return AnyView(
                Button(action: {
                    isShowingActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                }
            )
        }
    }
    
    // MARK: - Computed Vars
    
    var isLeader: Bool {
        group.leaderID == currentUser.id
    }
    
    var profileImage: UIImage? {
        guard let imageName = group.imageName else {
            return nil
        }
        
        return ImageUtility.loadImageFromDocuments(named: imageName)
    }
    
    var bannerImage: UIImage? {
        guard let bannerName = group.bannerImageName else {
            return nil
        }
        
        return ImageUtility.loadImageFromDocuments(named: bannerName)
    }
    
    var memberUsers: [User] {
        users.filter { group.memberIDs.contains($0.id ?? -1) }
    }
    
    // MARK: - Functions
    
    //placeholder, implement in view model
    func leaveGroup() {
        guard let currentID = currentUser.id else { return }
        var updatedGroup = group
        updatedGroup.memberIDs.removeAll { $0 == currentID }
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index] = updatedGroup
        }
        dismiss()
    }
}

#Preview {
    GroupDetailView(
        group: SampleData.sampleGroups.first!,
        currentUser: SampleData.sampleUsers.first!,
        users: SampleData.sampleUsers,
        groups: .constant(SampleData.sampleGroups)
    )
}
