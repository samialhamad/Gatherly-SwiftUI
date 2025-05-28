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
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var isDeleting = false
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    let group: UserGroup
    
    var body: some View {
        NavigationStack {
            if let currentUser = usersViewModel.currentUser {
                ZStack {
                    ScrollView {
                        VStack(spacing: Constants.GroupDetailView.vstackSpacing) {
                            AvatarHeaderView(group: group)
                            groupLeaderAndMembersView
                            Spacer()
                        }
                    }
                    
                    if isDeleting {
                        ActivityIndicator(message: Constants.GroupDetailView.deletingGroupString)
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
        Dictionary(uniqueKeysWithValues: usersViewModel.users.compactMap { user in
            guard let id = user.id else {
                return nil
            }
            
            return (id, user)
        })
    }
    
    // MARK: - Functions
    
    func leaveGroup() {
        guard var currentUser = usersViewModel.currentUser else {
            return
        }

        guard let userID = currentUser.id else {
            return
        }
        
        currentUser.groupIDs?.removeAll(where: { $0 == group.id })

        var updatedGroup = group
        updatedGroup.memberIDs.removeAll(where: { $0 == currentUser.id })

        usersViewModel.update(currentUser)
        groupsViewModel.update(updatedGroup)
        
        dismiss()
    }
    
    // MARK: - Subviews
    
    var editGroupSheet: some View {
        EditGroupView(
            editGroupViewModel: EditGroupViewModel(group: group),
            friendsDict: friendsDict,
            onSave: { _ in
                isShowingEditView = false
            },
            onCancel: {
                isShowingEditView = false
            },
            onDelete: { deletedGroup in
                groupsViewModel.delete(deletedGroup)
                isDeleting = false
                isShowingEditView = false
                dismiss()
            }
        )
    }
    
    var groupLeaderAndMembersView: some View {
        let resolvedLeader: User? = group.leaderID == usersViewModel.currentUser?.id
            ? usersViewModel.currentUser
            : friendsDict[group.leaderID]

        let memberUsers: [User] = group.memberIDs.compactMap { id in
            id == usersViewModel.currentUser?.id ? usersViewModel.currentUser : friendsDict[id]
        }
        
        return Group {
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
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var toolbarButton: some View {
        if group.leaderID == usersViewModel.currentUser?.id {
            AnyView(
                Button("Edit") {
                    isShowingEditView = true
                }
                    .accessibilityIdentifier("editGroupButton")
            )
        } else {
            AnyView(
                Button(action: {
                    isShowingActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                }
                    .accessibilityIdentifier("groupOptionsButton")
            )
        }
    }
}

#Preview {
    GroupDetailView(group: SampleData.sampleGroups.first!)
}
