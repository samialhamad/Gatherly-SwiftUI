//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import SwiftUI

struct GroupDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var groups: [UserGroup]
    @State private var isDeleting = false
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    
    let currentUser: User
    let friendsDict: [Int: User]
    let group: UserGroup
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: Constants.GroupDetailView.vstackSpacing) {
                    AvatarHeaderView(
                        group: group
                    )
                    
                    groupLeaderAndMembersView
                    
                    Spacer()
                }
            }
            
            if isDeleting {
                ActivityIndicator(message: "Deleting your group…")
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

private extension GroupDetailView {
    
    // MARK: - Computed Vars
    
    var isLeader: Bool {
        group.leaderID == currentUser.id
    }
    
    var memberUsers: [User] {
        group.memberIDs.compactMap { id in
            if id == currentUser.id {
                return currentUser
            }
            return friendsDict[id]
        }
    }
    
    var resolvedLeader: User? {
        group.leaderID == currentUser.id ? currentUser : friendsDict[group.leaderID]
    }
    
    // MARK: - Functions
    
    func leaveGroup() {
        guard let currentID = currentUser.id else { return }
        
        var updatedGroup = group
        updatedGroup.memberIDs.removeAll { $0 == currentID }
        
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index] = updatedGroup
        }
        
        if var groupIDs = currentUser.groupIDs {
            groupIDs.removeAll { $0 == group.id }
            currentUser.groupIDs = groupIDs
        }
        
        UserDefaultsManager.saveGroups(groups)
        UserDefaultsManager.saveUsers([currentUser])
        
        dismiss()
    }
    
    
    // MARK: - Subviews
    
    var editGroupSheet: some View {
        EditGroupView(
            viewModel: EditGroupViewModel(group: group),
            currentUser: currentUser,
            friendsDict: friendsDict,
            groups: groups,
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
                isDeleting = true
                Task {
                    let updatedGroups = await GatherlyAPI.deleteGroup(deletedGroup)
                    await MainActor.run {
                        groups = updatedGroups
                        isShowingEditView = false
                        isDeleting = false
                        dismiss()
                    }
                }
            }
        )
    }
    
    var groupLeaderAndMembersView: some View {
        Group {
            if let leader = resolvedLeader {
                Text("Leader")
                    .font(.headline)
                
                NavigationLink(destination: ProfileDetailView( currentUser: currentUser, user: leader)) {
                    ProfileRow(user: leader)
                }
            }
            
            if !memberUsers.isEmpty {
                Text("Members")
                    .font(.headline)
                
                ForEach(memberUsers, id: \.id) { user in
                    NavigationLink(destination: ProfileDetailView( currentUser: currentUser, user: user)) {
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
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })
    
    GroupDetailView(
        groups: .constant(SampleData.sampleGroups),
        currentUser: currentUser,
        friendsDict: friendsDict,
        group: SampleData.sampleGroups.first!
    )
}
