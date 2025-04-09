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
                SearchBarView(searchText: $viewModel.searchText, placeholder: "Search by name")
                
                if !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                    List(viewModel.filteredUsers, id: \.id) { user in
                        NavigationLink(destination: ProfileDetailView(user: user)) {
                            ProfileRow(user: user)
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
