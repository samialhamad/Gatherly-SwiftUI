//
//  CreateGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI
import PhotosUI

struct CreateGroupView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false
    @StateObject private var viewModel: CreateGroupViewModel
    
    init(currentUserID: Int) {
        _viewModel = StateObject(wrappedValue: CreateGroupViewModel(currentUserID: currentUserID))
    }
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friends: [User] {
        currentUser?.resolvedFriends(from: session.friendsDict) ?? []
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Group Name")) {
                        TextField("Enter group name", text: groupNameBinding)
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
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    createButtonSection
                }
                if isSaving {
                    ActivityIndicator(message: "Creating your group…")
                }
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
    
    // MARK: - Bindings
    
    var groupNameBinding: Binding<String> {
        Binding(
            get: { viewModel.group.name ?? "" },
            set: { viewModel.group.name = $0 }
        )
    }
    
    var memberIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { Set(viewModel.group.memberIDs) },
            set: { viewModel.group.memberIDs = Array($0).sorted() }
        )
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
            Button {
                isSaving = true
                Task {
                    let newGroup = await viewModel.createGroup()
                    await MainActor.run {
                        session.groups.append(newGroup)
                        session.navigationState.navigateToGroup = newGroup
                        session.navigationState.selectedTab = 2
                        isSaving = false
                        dismiss()
                    }
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(viewModel.isFormEmpty ? .gray : Color(Colors.primary))
            }
            .disabled(viewModel.isFormEmpty || isSaving)
        }
    }
}

#Preview {
    CreateGroupView(currentUserID: 1)
        .environmentObject(AppSession())
}
