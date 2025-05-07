//
//  FriendsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import Foundation

class FriendsListViewModel: ObservableObject {
    @Published var searchText: String = ""

    private let allFriends: [User]

    init(friends: [User]) {
        self.allFriends = friends
    }

    var filteredFriends: [User] {
        if searchText.isEmpty {
            return allFriends
        }

        let lowercasedQuery = searchText.lowercased()

        return allFriends.filter { user in
            (user.firstName?.lowercased().contains(lowercasedQuery) ?? false)
            || (user.lastName?.lowercased().contains(lowercasedQuery) ?? false)
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
}
