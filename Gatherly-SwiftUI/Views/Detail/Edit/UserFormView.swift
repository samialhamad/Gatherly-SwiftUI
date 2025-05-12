//
//  UserFormView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct UserFormView: View {
    @State private var isSaving = false
    @State private var showingDeleteAlert = false
    
    let store: Store<UserFormFeature.State, UserFormFeature.Action>
    let onComplete: (UserFormFeature.Action) -> Void
    
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
                    ActivityIndicator(message: "Saving your changes…")
                }
            }
            .keyboardDismissable()
        }
    }
}

private extension UserFormView {
    
    // MARK: - Form Views
    
    private func nameSection(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some View {
        Section(header: Text("Name")) {
            TextField("First Name", text: viewStore.binding(
                get: \.firstName,
                send: UserFormFeature.Action.setFirstName
            ))
            TextField("Last Name", text: viewStore.binding(
                get: \.lastName,
                send: UserFormFeature.Action.setLastName
            ))
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
                onComplete(.cancel)
            }
        }
    }
    
    func saveToolbarButton(_ viewStore: ViewStore<UserFormFeature.State, UserFormFeature.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                viewStore.send(.saveChanges)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onComplete(.delegate(.didSave(viewStore.currentUser)))
                }
            }
            .disabled(viewStore.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .foregroundColor(Color(Colors.secondary))
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
        ),
        onComplete: { _ in }
    )
}
