//
//  EditProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct EditProfileView: View {
    let store: Store<EditProfileFeature.State, EditProfileFeature.Action>
    let onComplete: (EditProfileFeature.Action) -> Void
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
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
                    
                    saveAndCancelSection(viewStore: viewStore)
                }
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            viewStore.send(.cancel)
                            onComplete(.cancel)
                        }
                    }
                }
            }
            .keyboardDismissable()
        }
    }
    
    @ViewBuilder
    private func saveAndCancelSection(viewStore: ViewStore<EditProfileFeature.State, EditProfileFeature.Action>) -> some View {
        Section {
            Button("Save") {
                viewStore.send(.saveChanges)
            }
            .foregroundColor(Color(Colors.primary))
        }
    }
}
