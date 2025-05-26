//
//  FriendsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import Foundation

class FriendsListViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    func filteredFriends(from friends: [User], searchText: String) -> [User] {
        if searchText.isEmpty {
            return friends
        }
        let query = searchText.lowercased()
        
        return friends.filter {
            ($0.firstName?.lowercased().contains(query) ?? false) ||
            ($0.lastName?.lowercased().contains(query) ?? false)
        }
    }
    
    func groupedFriends(from friends: [User]) -> [String: [User]] {
        Dictionary(grouping: friends) { user in
            user.firstName?.first.map { String($0).uppercased() } ?? ""
        }
    }
    
    func sortedSectionKeys(from friends: [User]) -> [String] {
        let grouped = groupedFriends(from: friends)
        return grouped.keys.sorted()
    }
}
