//
//  GroupFormView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import SwiftUI

struct GroupFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var groupFormViewModel: GroupFormViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var isSaving = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var showingDeleteAlert = false
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    private let onSave: ((UserGroup) -> Void)?
    private let onCancel: (() -> Void)?
    private let onDelete: ((UserGroup) -> Void)?
    
    // create mode init
    
    init(currentUserID: Int) {
        let groupFormViewModel = GroupFormViewModel(mode: .create, currentUserID: currentUserID)
        _groupFormViewModel = StateObject(wrappedValue: groupFormViewModel)
        
        self.onSave = nil
        self.onCancel = nil
        self.onDelete = nil
    }
    
    // edit mode init
    init(
        existingGroup: UserGroup,
        onSave: @escaping (UserGroup) -> Void,
        onCancel: @escaping () -> Void,
        onDelete: @escaping (UserGroup) -> Void
    ) {
        let groupFormViewModel = GroupFormViewModel(mode: .edit, existingGroup: existingGroup)
        _groupFormViewModel = StateObject(wrappedValue: groupFormViewModel)
        
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section(header: Text("Group Name")) {
                        TextField("Enter group name", text: groupNameBinding)
                            .accessibilityIdentifier("groupNameTextField")
                    }
                    
                    ImagePicker(
                        title: "Group Image",
                        imageHeight: Constants.GroupFormView.groupImageHeight,
                        maskShape: .circle,
                        selectedImage: $groupFormViewModel.groupImage
                    )
                    
                    ImagePicker(
                        title: "Banner Image",
                        imageHeight: Constants.GroupFormView.groupBannerImageHeight,
                        maskShape: .rectangle,
                        selectedImage: $groupFormViewModel.bannerImage
                    )
                    
                    EventMembersSection(
                        selectedMemberIDs: memberIDsBinding,
                        header: "Invite Friends"
                    )
                    
                    if groupFormViewModel.mode == .create {
                        createButtonSection
                    } else {
                        deleteButtonSection
                    }
                }
                .navigationTitle(
                    groupFormViewModel.mode == .create ? "New Group" : "Edit Group"
                )
                .toolbar {
                    cancelToolbarItem
                    
                    if groupFormViewModel.mode == .edit {
                        saveToolbarItem
                    }
                }
                .alert("Delete Group?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let original = groupFormViewModel.originalGroup {
                            onDelete?(original)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete this group?")
                }
            }
            
            if isSaving {
                ActivityIndicator(
                    message: groupFormViewModel.mode == .create
                    ? Constants.GroupFormView.creatingGroupString
                    : Constants.GroupFormView.savingChangesString
                )
            }
        }
        .keyboardDismissable()
    }
    
    // MARK: – Bindings
    
    private var groupNameBinding: Binding<String> {
        Binding<String>(
            get: { groupFormViewModel.group.name ?? "" },
            set: { groupFormViewModel.group.name = $0 }
        )
    }
    
    private var memberIDsBinding: Binding<Set<Int>> {
        Binding<Set<Int>>(
            get: { Set(groupFormViewModel.group.memberIDs) },
            set: { groupFormViewModel.group.memberIDs = Array($0).sorted() }
        )
    }
    
    // MARK: – Toolbar Items
    
    private var cancelToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                switch groupFormViewModel.mode {
                case .create:
                    dismiss()
                case .edit:
                    onCancel?()
                }
            }
        }
    }
    
    private var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                guard !groupFormViewModel.isFormEmpty && !isSaving else {
                    return
                }
                isSaving = true
                
                Task {
                    let preparedGroup = await groupFormViewModel.prepareGroup()
                    groupsViewModel.update(preparedGroup)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSaving = false
                        onSave?(preparedGroup)
                    }
                }
            }
            .accessibilityIdentifier("saveGroupButton")
            .foregroundColor(
                groupFormViewModel.isFormEmpty
                ? .gray
                : Color(Colors.secondary)
            )
            .disabled(groupFormViewModel.isFormEmpty || isSaving)
        }
    }
    
    // MARK: – Buttons
    
    private var createButtonSection: some View {
        Section {
            Button {
                guard !groupFormViewModel.isFormEmpty && !isSaving else {
                    return
                }
                isSaving = true
                
                Task {
                    let newGroup = await groupFormViewModel.prepareGroup()
                    groupsViewModel.create(newGroup) { createdGroup in
                        navigationState.navigateToGroup = createdGroup
                        navigationState.switchToTab(.friends)
                        DispatchQueue.main.async {
                            isSaving = false
                            dismiss()
                        }
                    }
                }
            } label: {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(
                        groupFormViewModel.isFormEmpty
                        ? .gray
                        : Color(Colors.primary)
                    )
            }
            .accessibilityIdentifier("createGroupButton")
            .disabled(groupFormViewModel.isFormEmpty || isSaving)
        }
    }
    
    private var deleteButtonSection: some View {
        Section {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .accessibilityIdentifier("deleteGroupButton")
            .foregroundColor(.red)
        }
    }
}
