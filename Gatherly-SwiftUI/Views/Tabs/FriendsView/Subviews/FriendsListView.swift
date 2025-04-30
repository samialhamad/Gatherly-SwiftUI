//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsListView: View {
    let currentUserID: Int
    let users: [User]
    
    @Binding var searchText: String
    @StateObject private var viewModel: FriendsListViewModel
    
    init(searchText: Binding<String>, currentUserID: Int, users: [User]) {
        _searchText = searchText
        self.currentUserID = currentUserID
        self.users = users
        _viewModel = StateObject(wrappedValue: FriendsListViewModel(
            currentUserID: currentUserID,
            allUsers: users
        ))
    }
    
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
    
    // MARK: - Subviews
    
    func friendList(proxy: ScrollViewProxy) -> some View {
        List {
            ForEach(viewModel.sortedSectionKeys, id: \.self) { key in
                Section(header: Text(key).id(key)) {
                    ForEach(
                        viewModel.groupedFriends[key]?.sorted(by: { ($0.firstName ?? "") < ($1.firstName ?? "") }) ?? [],
                        id: \.id
                    ) { friend in
                        NavigationLink(destination: ProfileDetailView(
                            currentUser: users.first(where: { $0.id == currentUserID }) ?? friend,
                            user: friend
                        )) {
                            ProfileRow(user: friend)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.searchText = searchText
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue
        }
    }
    
    func alphabetOverlay(proxy: ScrollViewProxy) -> some View {
        Group {
            if viewModel.searchText.isEmpty {
                AlphabetIndexView(letters: viewModel.sortedSectionKeys) { letter in
                    withAnimation {
                        proxy.scrollTo(letter, anchor: .top)
                    }
                }
                .padding(.trailing, Constants.FriendsListView.overlayTrailingPadding)
            }
        }
    }
}
