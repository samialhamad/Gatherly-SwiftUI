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
    func userFormViewDidCancel()
    func userFormViewDidUpdateUser(updatedUser: User)
}

struct UserFormView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showingDeleteAlert = false
    
    let store: Store<UserFormReducer.State, UserFormReducer.Action>
    var delegate: UserFormViewDelegate?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                NavigationStack {
                    Form {
                        nameSection(viewStore)
                        imagePickersSection(viewStore)
                    }
                    .navigationTitle(navigationTitle(for: viewStore.mode))
                    .toolbar {
                        cancelToolbarButton(viewStore)
                        saveToolbarButton(viewStore)
                    }
                }
                .onChange(of: viewStore.didUpdateUser) {
                    if viewStore.didUpdateUser {
                        didUpdateUser(updatedUser: viewStore.currentUser)
                    }
                }
                if viewStore.isSaving {
                    ActivityIndicator(message: activityMessage(for: viewStore))
                }
            }
            .keyboardDismissable()
        }
    }
}

private extension UserFormView {
    
    // MARK: - Functions
    
    private func didUpdateUser(updatedUser: User) {
        delegate?.userFormViewDidUpdateUser(updatedUser: updatedUser)
    }
    
    // MARK: - Subviews
    
    private func activityMessage(for viewStore: ViewStore<UserFormReducer.State, UserFormReducer.Action>) -> String {
        switch viewStore.mode {
        case .createFriend:
            return Constants.UserFormView.addingFriendString
        case .updateCurrentUser:
            return Constants.UserFormView.updatingProfileString
        case .updateFriend:
            return Constants.UserFormView.updatingFriendString
        }
    }
    
    private func nameSection(_ viewStore: ViewStore<UserFormReducer.State, UserFormReducer.Action>) -> some View {
        Section(header: Text("Name")) {
            TextField("First Name", text: viewStore.binding(
                get: \.firstName,
                send: UserFormReducer.Action.setFirstName
            ))
            .accessibilityIdentifier("userFormFirstName")
            TextField("Last Name", text: viewStore.binding(
                get: \.lastName,
                send: UserFormReducer.Action.setLastName
            ))
            .accessibilityIdentifier("userFormLastName")
        }
    }
    
    private func navigationTitle(for mode: UserFormReducer.State.Mode) -> String {
        switch mode {
        case .createFriend:
            return "New Friend"
        case .updateCurrentUser:
            return "Edit Profile"
        case .updateFriend:
            return "Edit Friend"
        }
    }
    
    private func imagePickersSection(_ viewStore: ViewStore<UserFormReducer.State, UserFormReducer.Action>) -> some View {
        Group {
            ImagePicker(
                title: "Avatar Image",
                imageHeight: Constants.CreateGroupView.groupImageHeight,
                maskShape: .circle,
                selectedImage: viewStore.binding(
                    get: \.avatarImage,
                    send: UserFormReducer.Action.setAvatarImage
                )
            )
            
            ImagePicker(
                title: "Banner Image",
                imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                maskShape: .rectangle,
                selectedImage: viewStore.binding(
                    get: \.bannerImage,
                    send: UserFormReducer.Action.setBannerImage
                )
            )
        }
    }
    
    // MARK: - Buttons
    
    func cancelToolbarButton(_ viewStore: ViewStore<UserFormReducer.State, UserFormReducer.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                viewStore.send(.cancel)
                delegate?.userFormViewDidCancel()
            }
        }
    }
    
    func saveToolbarButton(_ viewStore: ViewStore<UserFormReducer.State, UserFormReducer.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            let isDisabled = viewStore.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            
            Button("Save") {
                viewStore.send(.saveChanges)
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
            initialState: UserFormReducer.State(
                currentUser: SampleData.sampleUsers.first!,
                firstName: "Sami",
                lastName: "Alhamad",
                avatarImageName: nil,
                bannerImageName: nil,
                mode: .updateCurrentUser
            ),
            reducer: { UserFormReducer() }
        )
    )
}
