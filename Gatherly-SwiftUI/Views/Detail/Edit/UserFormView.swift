//
//  UserFormView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

protocol UserFormViewDelegate {
    func userFormViewDidUpdateUser(updatedUser: User)
}

struct UserFormView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isSaving = false
    @State private var showingDeleteAlert = false
    
    let store: Store<UserFormFeature.State, UserFormFeature.Action>
    var delegate: UserFormViewDelegate?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                NavigationStack {
                    Form {
                        nameSection(viewStore)
                        imagePickersSection(viewStore)
                    }
                    .navigationTitle(viewStore.isCreatingFriend ? "New Friend" : "Edit Profile")
                    .toolbar {
                        cancelToolbarButton(viewStore)
                        saveToolbarButton(viewStore)
                    }
                }
                if isSaving {
                    ActivityIndicator(message: activityMessage(for: viewStore))
                }
            }
            .keyboardDismissable()
        }
    }
}

private extension UserFormView {
    
    // MARK: - Subviews
    
    private func activityMessage(for viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> String {
        if viewStore.isCreatingFriend {
            return Constants.UserFormView.addingFriendString
        } else if viewStore.currentUser.id == 1 {
            return Constants.UserFormView.updatingProfileString
        } else {
            return Constants.UserFormView.updatingFriendString
        }
    }
    
    private func nameSection(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some View {
        Section(header: Text("Name")) {
            TextField("First Name", text: viewStore.binding(
                get: \.firstName,
                send: UserFormFeature.Action.setFirstName
            ))
            .accessibilityIdentifier("userFormFirstName")
            TextField("Last Name", text: viewStore.binding(
                get: \.lastName,
                send: UserFormFeature.Action.setLastName
            ))
            .accessibilityIdentifier("userFormLastName")
        }
    }
    
    private func imagePickersSection(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some View {
        Group {
            ImagePicker(
                title: "Avatar Image",
                imageHeight: Constants.CreateGroupView.groupImageHeight,
                maskShape: .circle,
                selectedImage: viewStore.binding(
                    get: \.avatarImage,
                    send: UserFormFeature.Action.setAvatarImage
                )
            )
            
            ImagePicker(
                title: "Banner Image",
                imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                maskShape: .rectangle,
                selectedImage: viewStore.binding(
                    get: \.bannerImage,
                    send: UserFormFeature.Action.setBannerImage
                )
            )
        }
    }
    
    // MARK: - Buttons
    
    func cancelToolbarButton(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                viewStore.send(.cancel)
            }
        }
    }
    
    func saveToolbarButton(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            let isDisabled = viewStore.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            
            Button("Save") {
                isSaving = true
                viewStore.send(.saveChanges)
                delegate?.userFormViewDidUpdateUser(updatedUser: viewStore.currentUser)
                
            }
            .accessibilityIdentifier("userFormSaveButton")
            .disabled(isDisabled)
            .foregroundColor(isDisabled ? .gray : Color(Colors.secondary))
        }
    }
}

#Preview {
    UserFormView(
        store: Store(
            initialState: UserFormFeature.State(
                currentUser: SampleData.sampleUsers.first!,
                firstName: "Sami",
                lastName: "Alhamad",
                avatarImageName: nil,
                bannerImageName: nil
            ),
            reducer: { UserFormFeature() }
        )
    )
}
