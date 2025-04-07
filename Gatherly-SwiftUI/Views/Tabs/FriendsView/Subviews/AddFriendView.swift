//
//  AddFriendView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddFriendViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.didSyncContacts {
                    Button("Sync Contacts") {
                        viewModel.syncContacts()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                SearchBarView(searchText: $viewModel.searchText, placeholder: "Search by name")
                
                if !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                    List(viewModel.filteredUsers, id: \.id) { user in
                        HStack {
                            ProfileRow(user: user)
                            Spacer()
                            Button("Add") {
                                viewModel.sendFriendRequest(to: user)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .keyboardDismissable()
    }
}
