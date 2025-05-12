//
//  EditProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct EditProfileView: View {
    @State private var isSaving = false
    @State private var showingDeleteAlert = false
    
    let store: Store<EditProfileFeature.State, EditProfileFeature.Action>
    let onComplete: (EditProfileFeature.Action) -> Void
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                NavigationStack {
                    Form {
                        nameSection(viewStore)
                        imagePickersSection(viewStore)
                        
                        if !viewStore.isCreatingContact {
                            deleteButton
                        }
                    }
                    .navigationTitle(viewStore.isCreatingContact ? "New Contact" : "Edit Profile")
                    .toolbar {
                        cancelToolbarButton(viewStore)
                        saveToolbarButton(viewStore)
                    }
                    .alert("Delete Profile?", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            // Placeholder: no delete functionality yet
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to delete your profile?")
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

private extension EditProfileView {
    
    // MARK: - Form Views
    
    private func nameSection(_ viewStore: ViewStore<EditProfileFeature.State, EditProfileFeature.Action>) -> some View {
        Section(header: Text("Name")) {
            TextField("First Name", text: viewStore.binding(
                get: \.firstName,
                send: EditProfileFeature.Action.setFirstName
            ))
            TextField("Last Name", text: viewStore.binding(
                get: \.lastName,
                send: EditProfileFeature.Action.setLastName
            ))
        }
    }
    
    private func imagePickersSection(_ viewStore: ViewStore<EditProfileFeature.State, EditProfileFeature.Action>) -> some View {
        Group {
            ImagePicker(
                title: "Avatar Image",
                imageHeight: Constants.CreateGroupView.groupImageHeight,
                maskShape: .circle,
                selectedImage: viewStore.binding(
                    get: \.avatarImage,
                    send: EditProfileFeature.Action.setAvatarImage
                )
            )
            
            ImagePicker(
                title: "Banner Image",
                imageHeight: Constants.CreateGroupView.groupBannerImageHeight,
                maskShape: .rectangle,
                selectedImage: viewStore.binding(
                    get: \.bannerImage,
                    send: EditProfileFeature.Action.setBannerImage
                )
            )
        }
    }
    
    // MARK: - Buttons
    
    func cancelToolbarButton(_ viewStore: ViewStore<EditProfileFeature.State, EditProfileFeature.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                viewStore.send(.cancel)
                onComplete(.cancel)
            }
        }
    }
    
    var deleteButton: some View {
        Section {
            Button("Delete Profile") {
                showingDeleteAlert = true
            }
            .foregroundColor(.red)
        }
    }
    
    func saveToolbarButton(_ viewStore: ViewStore<EditProfileFeature.State, EditProfileFeature.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                isSaving = true
                viewStore.send(.saveChanges)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onComplete(.delegate(.didSave(viewStore.currentUser)))
                }
            }
            .foregroundColor(Color(Colors.secondary))
        }
    }
}

#Preview {
    EditProfileView(
        store: Store(
            initialState: EditProfileFeature.State(
                currentUser: SampleData.sampleUsers.first!,
                firstName: "Sami",
                lastName: "Alhamad",
                avatarImageName: nil,
                bannerImageName: nil
            ),
            reducer: { EditProfileFeature() }
        ),
        onComplete: { _ in }
    )
}
