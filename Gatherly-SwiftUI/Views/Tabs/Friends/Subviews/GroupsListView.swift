//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import SwiftUI

struct GroupsListView: View {
    @StateObject private var groupsListViewModel = GroupsListViewModel()
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
        groupsListViewModel.filteredGroups(
            from: groupsViewModel.groups,
            searchText: searchText)
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
                binding.wrappedValue = groupsListViewModel.toggledGroupSelection(
                    for: group.memberIDs,
                    in: binding.wrappedValue
                )
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
