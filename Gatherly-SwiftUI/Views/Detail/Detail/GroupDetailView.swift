//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import SwiftUI

struct GroupDetailView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var isDeleting = false
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    
    let group: UserGroup
    
    private var currentUser: User? {
        session.currentUser
    }
    
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
    }
}

private extension GroupDetailView {
    
    // MARK: - Functions
    
    func leaveGroup() {
        guard let currentID = currentUser?.id else {
            return
        }
        
        var updatedGroup = group
        updatedGroup.memberIDs.removeAll { $0 == currentID }
        
        if let index = session.groups.firstIndex(where: { $0.id == group.id }) {
            session.groups[index] = updatedGroup
        }
        
        if var groupIDs = currentUser?.groupIDs {
            groupIDs.removeAll { $0 == group.id }
            currentUser?.groupIDs = groupIDs
        }
        
        UserDefaultsManager.saveGroups(session.groups)
        if let updatedCurrentUser = currentUser {
            UserDefaultsManager.saveUsers([updatedCurrentUser])
        }
        
        dismiss()
    }
    
    // MARK: - Subviews
    
    var editGroupSheet: some View {
        EditGroupView(
            viewModel: EditGroupViewModel(group: group),
            friendsDict: session.friendsDict,
            groups: session.groups,
            onSave: { updatedGroup in
                if let index = session.groups.firstIndex(where: { $0.id == updatedGroup.id }) {
                    session.groups[index] = updatedGroup
                    UserDefaultsManager.saveGroups(session.groups)
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
                        session.groups = updatedGroups
                        isShowingEditView = false
                        isDeleting = false
                        dismiss()
                    }
                }
            }
        )
    }
    
    var groupLeaderAndMembersView: some View {
        let friendsDict = session.friendsDict
        
        let resolvedLeader: User? = group.leaderID == currentUser?.id ? currentUser : friendsDict[group.leaderID]
        
        let memberUsers: [User] = group.memberIDs.compactMap { id in
            id == currentUser?.id ? currentUser : friendsDict[id]
        }
        
        return Group {
            if let leader = resolvedLeader {
                Text("Leader")
                    .font(.headline)
                NavigationLink(destination: ProfileDetailView(user: leader)) {
                    ProfileRow(user: leader)
                }
            }
            if !memberUsers.isEmpty {
                Text("Members")
                    .font(.headline)
                ForEach(memberUsers, id: \.id) { user in
                    NavigationLink(destination: ProfileDetailView(user: user)) {
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
        if group.leaderID == currentUser?.id {
            AnyView(
                Button("Edit") {
                    isShowingEditView = true
                }
            )
        } else {
            AnyView(
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
    GroupDetailView(group: SampleData.sampleGroups.first!)
        .environmentObject(AppSession())
}
