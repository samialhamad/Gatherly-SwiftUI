//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Binding var searchText: String
    @StateObject private var viewModel = FriendsListViewModel()
    
    let currentUser: User
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ScrollViewReader { proxy in
                friendList(proxy: proxy)
                    .overlay(alphabetOverlay(proxy: proxy), alignment: .trailing)
            }
        }
    }
}

private extension FriendsListView {
    
    // MARK: - Computed Vars
    
    private var filteredFriends: [User] {
        viewModel.filteredFriends(from: contentViewModel.friends)
    }
    
    private var groupedFriends: [String: [User]] {
        viewModel.groupedFriends(from: filteredFriends)
    }
    
    private var sortedSectionKeys: [String] {
        viewModel.sortedSectionKeys(from: filteredFriends)
    }
    
    // MARK: - Subviews
    
    func friendList(proxy: ScrollViewProxy) -> some View {
        List {
            ForEach(sortedSectionKeys, id: \.self) { key in
                Section(header: Text(key).id(key)) {
                    ForEach(
                        groupedFriends[key]?.sorted(by: { ($0.firstName ?? "") < ($1.firstName ?? "") }) ?? [],
                        id: \.id
                    ) { friend in
                        NavigationLink(destination: ProfileDetailView(
                            currentUser: currentUser,
                            user: friend
                        )) {
                            ProfileRow(user: friend)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
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
}
