//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsListView: View {
    private let currentUserID = 1
    private let allUsers = SampleData.sampleUsers
    
    @Binding var searchText: String
    
    var friends: [User] {
        guard let currentUser = allUsers.first(where: { $0.id == currentUserID }),
              let friendIDs = currentUser.friendIDs else { return [] }
        return allUsers.filter { friendIDs.contains($0.id ?? 0) }
    }
    
    var filteredFriends: [User] {
        if searchText.isEmpty {
            return friends
        } else {
            let lowercasedQuery = searchText.lowercased()
            return friends.filter { user in
                (user.firstName?.lowercased().contains(lowercasedQuery) ?? false)
                || (user.lastName?.lowercased().contains(lowercasedQuery) ?? false)
            }
        }
    }
    
    var groupedFriends: [String: [User]] {
        Dictionary(grouping: filteredFriends) { user in
            let firstLetter = user.firstName?.first.map { String($0).uppercased() } ?? ""
            return firstLetter
        }
    }
    
    var sortedSectionKeys: [String] {
        groupedFriends.keys.sorted()
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ScrollViewReader { proxy in
                List {
                    ForEach(sortedSectionKeys, id: \.self) { key in
                        Section(header: Text(key).id(key)) {
                            ForEach(groupedFriends[key]?.sorted { ($0.firstName ?? "") < ($1.firstName ?? "") } ?? [], id: \.id) { friend in
                                NavigationLink(destination: ProfileDetailView(user: friend)) {
                                    ProfileRow(user: friend)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .overlay(
                    Group {
                        if searchText.isEmpty {
                            AlphabetIndexView(letters: sortedSectionKeys) { letter in
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }
                            .padding(.trailing, Constants.FriendsListView.overlayTrailingPadding)
                        }
                    },
                    alignment: .trailing
                )
            }
        }
    }
}
