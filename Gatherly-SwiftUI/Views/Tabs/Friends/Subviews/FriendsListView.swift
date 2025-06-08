//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import SwiftUI

enum SelectionMode {
    case view
    case select(selectedIDs: Binding<Set<Int>>)
}

struct FriendsListView: View {
    @Binding var searchText: String
    @EnvironmentObject var usersViewModel: UsersViewModel
    @StateObject private var friendsListViewModel = FriendsListViewModel()
    
    let mode: SelectionMode
    
    var body: some View {
        if usersViewModel.isLoading {
            ActivityIndicator(message: Constants.FriendsListView.loadingString)
        } else {
            ZStack(alignment: .trailing) {
                ScrollViewReader { proxy in
                    friendList(proxy: proxy)
                        .overlay(alphabetOverlay(proxy: proxy), alignment: .trailing)
                }
            }
            .onAppear {
                usersViewModel.loadIfNeeded()
            }
        }
    }
}

private extension FriendsListView {
    
    // MARK: - Computed Vars
    
    var friends: [User] {
        guard let currentUser = usersViewModel.currentUser else {
            return []
        }
        
        let ids = Set(currentUser.friendIDs ?? [])
        
        return usersViewModel.users.filter { user in
            guard let id = user.id else {
                return false
            }
            
            return ids.contains(id)
        }
    }
    
    private var filteredFriends: [User] {
        friendsListViewModel.filteredFriends(from: friends, searchText: searchText)
    }
    
    private var groupedFriends: [String: [User]] {
        friendsListViewModel.groupedFriends(from: filteredFriends)
    }
    
    private var sortedSectionKeys: [String] {
        friendsListViewModel.sortedSectionKeys(from: filteredFriends)
    }
    
    // MARK: - Functions
    
    private func toggleSelection(_ id: Int?, binding: Binding<Set<Int>>) {
        guard let id = id else {
            return
        }
        
        if binding.wrappedValue.contains(id) {
            binding.wrappedValue.remove(id)
        } else {
            binding.wrappedValue.insert(id)
        }
    }
    
    // MARK: - Subviews
    
    func alphabetOverlay(proxy: ScrollViewProxy) -> some View {
        Group {
            if friendsListViewModel.searchText.isEmpty {
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
            ForEach(friendsListViewModel.sortedSectionKeys(from: friendsListViewModel.filteredFriends(from: friends, searchText: searchText)), id: \.self) { key in
                Section(header: Text(key).id(key)) {
                    ForEach(friendsListViewModel.groupedFriends(
                        from: friendsListViewModel.filteredFriends(
                            from: friends,
                            searchText: searchText))[key] ?? []) { friend in
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
                UserRow(user: friend)
            }
            .accessibilityIdentifier("friendRow-\(friend.firstName ?? "")")
        case .select(let binding):
            Button {
                toggleSelection(friend.id, binding: binding)
            } label: {
                HStack {
                    UserRow(user: friend)
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
