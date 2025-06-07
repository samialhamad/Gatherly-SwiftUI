//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import Combine
import SwiftUI

struct GroupDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var groupDetailViewModel = GroupDetailViewModel()
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    let groupID: Int
    
    var body: some View {
        NavigationStack {
            if let group, let currentUser = usersViewModel.currentUser {
                ZStack {
                    ScrollView {
                        VStack(spacing: Constants.GroupDetailView.vstackSpacing) {
                            AvatarHeaderView(mode: .group(group: group))
                            groupLeaderAndMembersView
                            Spacer()
                        }
                    }
                }
                .navigationTitle(group.name ?? "")
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
                    editGroupSheet
                }
                .refreshOnAppear()
            }
        }
        .onAppear {
            usersViewModel.loadIfNeeded()
        }
    }
}

private extension GroupDetailView {
    
    // MARK: - Computed Vars
    
    var friendsDict: [Int: User] {
        groupDetailViewModel.friendsDict(for: usersViewModel.users)
    }
    
    var group: UserGroup? {
        groupDetailViewModel.group(forID: groupID, in: groupsViewModel.groups)
    }
    
    // MARK: - Functions
    
    func leaveGroup() {
        guard let currentUser = usersViewModel.currentUser,
              let currentUserID = currentUser.id,
              let group else {
            return
        }
        
        currentUser.groupIDs?.removeAll(where: { $0 == group.id })
        
        var updatedGroup = group
        updatedGroup.memberIDs.removeAll(where: { $0 == currentUserID })
        
        usersViewModel.update(currentUser)
        groupsViewModel.update(updatedGroup)
        
        dismiss()
    }
    
    // MARK: - Subviews
    
    var editGroupSheet: some View {
        let originalGroup = group!
        let currentUserID = usersViewModel.currentUser?.id ?? SampleData.currentUserID
        
        return GroupFormView(
            group: originalGroup,
            currentUserID: currentUserID,
            onSave: { savedGroup in
                groupsViewModel.update(savedGroup)
                isShowingEditView = false
            },
            onCancel: {
                isShowingEditView = false
            },
            onDelete: { groupToDelete in
                groupsViewModel.delete(groupToDelete)
                isShowingEditView = false
                dismiss()
            }
        )
    }
    
    var groupLeaderAndMembersView: some View {
        Group {
            if let group {
                let resolvedLeader: User? = group.leaderID == usersViewModel.currentUser?.id
                ? usersViewModel.currentUser
                : friendsDict[group.leaderID]
                
                let memberUsers: [User] = group.memberIDs.compactMap {
                    $0 == usersViewModel.currentUser?.id ? usersViewModel.currentUser : friendsDict[$0]
                }
                
                if let leader = resolvedLeader {
                    Text("Leader")
                        .font(.headline)
                    NavigationLink(destination: UserDetailView(user: leader)) {
                        ProfileRow(user: leader)
                    }
                    .accessibilityIdentifier("groupMemberRow-\(leader.firstName ?? "")")
                }
                
                if !memberUsers.isEmpty {
                    Text("Members")
                        .font(.headline)
                    ForEach(memberUsers, id: \.id) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            ProfileRow(user: user)
                        }
                        .accessibilityIdentifier("groupMemberRow-\(user.firstName ?? "")")
                    }
                }
            }
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var toolbarButton: some View {
        Group {
            if let group,
               group.leaderID == usersViewModel.currentUser?.id {
                Button("Edit") {
                    isShowingEditView = true
                }
                .accessibilityIdentifier("editGroupButton")
            } else {
                Button(action: {
                    isShowingActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                }
                .accessibilityIdentifier("groupOptionsButton")
            }
        }
    }
}

#Preview {
    GroupDetailView(groupID: SampleData.sampleGroups.first!.id!)
}
