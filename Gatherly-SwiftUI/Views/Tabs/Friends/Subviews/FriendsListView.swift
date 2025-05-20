//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var session: AppSession
    @Binding var searchText: String
    @StateObject private var viewModel = FriendsListViewModel()
    
    let mode: SelectionMode
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friends: [User] {
        currentUser?.resolvedFriends(from: session.friendsDict) ?? []
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ScrollViewReader { proxy in
                friendList(proxy: proxy)
                    .id(session.friendsRefreshID)
                    .overlay(alphabetOverlay(proxy: proxy), alignment: .trailing)
            }
        }
    }
}

private extension FriendsListView {
    
    // MARK: - Computed Vars
    
    private var filteredFriends: [User] {
        viewModel.filteredFriends(from: friends, searchText: searchText)
    }
    
    private var groupedFriends: [String: [User]] {
        viewModel.groupedFriends(from: filteredFriends)
    }
    
    private var sortedSectionKeys: [String] {
        viewModel.sortedSectionKeys(from: filteredFriends)
    }
    
    // MARK: - Functions
    
    private func toggleSelection(_ id: Int?, binding: Binding<Set<Int>>) {
        guard let id = id else { return }
        if binding.wrappedValue.contains(id) {
            binding.wrappedValue.remove(id)
        } else {
            binding.wrappedValue.insert(id)
        }
    }
    
    // MARK: - Subviews
    
    func alphabetOverlay(proxy: ScrollViewProxy) -> some View {
        Group {
            if viewModel.searchText.isEmpty {
                AlphabetIndexView(letters: sortedSectionKeys) { letter in
                    withAnimation {
                        proxy.scrollTo(letter, anchor: .top)
                    }
                }
                .padding(.trailing, Constants.FriendsListView.overlayTrailingPadding)
            }
        }
    }
    
    func friendList(proxy: ScrollViewProxy) -> some View {
        List {
            ForEach(viewModel.sortedSectionKeys(from: viewModel.filteredFriends(from: friends, searchText: searchText)), id: \.self) { key in
                Section(header: Text(key).id(key)) {
                    ForEach(viewModel.groupedFriends(from: viewModel.filteredFriends(from: friends, searchText: searchText))[key] ?? []) { friend in
                        rowView(for: friend)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func rowView(for friend: User) -> some View {
        switch mode {
        case .view:
            NavigationLink(destination: UserDetailView(user: friend)) {
                ProfileRow(user: friend)
            }
            .accessibilityIdentifier("friendRow-\(friend.firstName ?? "")")
        case .select(let binding):
            Button {
                toggleSelection(friend.id, binding: binding)
            } label: {
                HStack {
                    ProfileRow(user: friend)
                    Spacer()
                    if binding.wrappedValue.contains(friend.id ?? -1) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color(Colors.primary))
                    }
                }
            }
        }
    }
}
