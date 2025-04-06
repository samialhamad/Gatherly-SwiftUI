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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(
                    group: group,
                    profileImage: profileImage,
                    bannerImage: bannerImage
                )
                
                VStack(spacing: 8) {
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
            if group.leaderID == currentUser.id {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        isShowingEditView = true
                    }
                }
            }
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
