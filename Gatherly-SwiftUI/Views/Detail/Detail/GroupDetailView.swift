//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import Combine
import SwiftUI

struct GroupDetailView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var currentUser: User? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var friendsDict: [Int: User] = [:]
    @State private var isDeleting = false
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    
    let group: UserGroup
    
    var body: some View {
        NavigationStack {
            if let currentUser {
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
            let currentUserPublisher = GatherlyAPI.getCurrentUser()
            let usersPublisher = GatherlyAPI.getUsers()
            
            Publishers.CombineLatest(currentUserPublisher, usersPublisher)
                .receive(on: RunLoop.main)
                .sink { currentUser, users in
                    self.currentUser = currentUser
                    self.friendsDict = Dictionary(uniqueKeysWithValues: users.compactMap { user in
                        guard let id = user.id else {
                            return nil
                        }
                        
                        return (id, user)
                    })
                }
                .store(in: &cancellables)
        }
    }
}

private extension GroupDetailView {
    
    // MARK: - Functions
    
    func leaveGroup() {
        guard let currentUser else { return }
        guard let userID = currentUser.id else { return }
        
        var updatedUser = currentUser
        updatedUser.groupIDs?.removeAll(where: { $0 == group.id })
        
        var updatedGroup = group
        updatedGroup.memberIDs.removeAll(where: { $0 == userID })
        
        GatherlyAPI.updateUser(updatedUser)
            .flatMap { _ in
                GatherlyAPI.updateGroup(updatedGroup)
            }
            .receive(on: RunLoop.main)
            .sink { _ in
                dismiss()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Subviews
    
    var editGroupSheet: some View {
        EditGroupView(
            viewModel: EditGroupViewModel(group: group),
            friendsDict: friendsDict,
            groups: [],
            onSave: { _ in
                isShowingEditView = false
            },
            onCancel: {
                isShowingEditView = false
            },
            onDelete: { deletedGroup in
                isDeleting = true
                
                GatherlyAPI.deleteGroup(deletedGroup)
                    .receive(on: RunLoop.main)
                    .sink { _ in
                        isDeleting = false
                        isShowingEditView = false
                        dismiss()
                    }
                    .store(in: &cancellables)
            }
        )
    }
    
    var groupLeaderAndMembersView: some View {
        let resolvedLeader: User? = group.leaderID == currentUser?.id
        ? currentUser
        : friendsDict[group.leaderID]
        
        let memberUsers: [User] = group.memberIDs.compactMap { id in
            id == currentUser?.id ? currentUser : friendsDict[id]
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
        if group.leaderID == currentUser?.id {
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
