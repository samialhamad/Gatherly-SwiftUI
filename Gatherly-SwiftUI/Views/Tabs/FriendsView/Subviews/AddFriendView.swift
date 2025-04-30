//
//  AddFriendView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct AddFriendView: View {
    @ObservedObject var currentUser: User
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddFriendViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchText: $viewModel.searchText, placeholder: "Search by name")
                searchResultsView
            }
            .navigationTitle("Add Friend")
            .toolbar {
                closeToolbarButton
            }
        }
        .keyboardDismissable()
    }
}

private extension AddFriendView {
    
    // MARK: - Subviews
    
    var closeToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Close") {
                dismiss()
            }
        }
    }
    
    var searchResultsView: some View {
        if !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return AnyView(
                List(viewModel.filteredUsers, id: \.id) { user in
                    NavigationLink(destination: ProfileDetailView(currentUser: currentUser, user: user)) {
                        ProfileRow(user: user)
                    }
                }
                .listStyle(.plain)
            )
        } else {
            return AnyView(Spacer())
        }
    }
}
