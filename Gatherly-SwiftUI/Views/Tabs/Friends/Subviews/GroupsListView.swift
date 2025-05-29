//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import SwiftUI

struct GroupsListView: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @Binding var searchText: String
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    let mode: SelectionMode
    
    var body: some View {
        Group {
            if groupsViewModel.isLoading || usersViewModel.isLoading {
                ActivityIndicator(message: Constants.GroupsListView.loadingString)
            } else {
                List(filteredGroups, id: \.id) { group in
                    rowView(for: group)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            groupsViewModel.loadIfNeeded()
            usersViewModel.loadIfNeeded()
        }
    }
}

private extension GroupsListView {
    
    // MARK: - Computed var
    
    var currentUser: User? {
        usersViewModel.currentUser
    }
    
    var filteredGroups: [UserGroup] {
        guard let currentUser else {
            return []
        }
        
        let userGroups = groupsViewModel.groups.filter { group in
            let isLeader = (group.leaderID == currentUser.id)
            let isMember = group.id.flatMap { currentUser.groupIDs?.contains($0) } ?? false
            
            return isLeader || isMember
        }
        
        if searchText.isEmpty {
            return userGroups
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return userGroups.filter {
                ($0.name ?? "").lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    // MARK: - Functions
    
    private func toggleGroupSelection(_ memberIDs: [Int], binding: Binding<Set<Int>>) {
        let allSelected = memberIDs.allSatisfy { binding.wrappedValue.contains($0) }
        
        if allSelected {
            memberIDs.forEach { binding.wrappedValue.remove($0) }
        } else {
            memberIDs.forEach { binding.wrappedValue.insert($0) }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func rowView(for group: UserGroup) -> some View {
        switch mode {
        case .view:
            if let id = group.id {
                NavigationLink(destination: GroupDetailView(groupID: id)) {
                    GroupRow(group: group)
                }
                .accessibilityIdentifier("groupRow-\(group.name ?? "")")
            }
            
        case .select(let binding):
            Button {
                toggleGroupSelection(group.memberIDs, binding: binding)
            } label: {
                HStack {
                    GroupRow(group: group)
                    Spacer()
                    if group.memberIDs.allSatisfy({ binding.wrappedValue.contains($0) }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color(Colors.primary))
                    }
                }
            }
        }
    }
}

#Preview {
    GroupsListView(searchText: .constant(""), mode: .view)
}
