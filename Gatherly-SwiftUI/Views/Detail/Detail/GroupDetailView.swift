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
    
    @Binding var groups: [UserGroup]
    @State private var isShowingEditView = false
    @State private var isShowingActionSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(
                    group: group,
                    profileImage: profileImage,
                    bannerImage: bannerImage
                )
                
                VStack(spacing: Constants.GroupDetailView.vstackSpacing) {
                    Text("Leader ID: \(group.leaderID)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(group.memberIDs.count) members")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
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
                    }
                    isShowingEditView = false
                },
                onCancel: {
                    isShowingEditView = false
                },
                onDelete: { deletedGroup in
                    groups = GroupEditor.deleteGroup(from: groups, groupToDelete: deletedGroup)
                    isShowingEditView = false
                    dismiss()
                }
            )
        }
    }
}

private extension GroupDetailView {
    
    // MARK: - Subviews
    
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

//#Preview {
//    GroupDetailView(group: UserGroup(
//        id: 1,
//        name: "Study Buddies",
//        memberIDs: [1, 2, 3],
//        leaderID: 1,
//        messages: [
//            Message(id: 1, userID: 1, message: "Hey team!", read: true)
//        ]
//    ))
//}
