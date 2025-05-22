//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import SwiftUI

struct GroupsListView: View {
    @State private var allGroups: [UserGroup] = []
    @State private var allUsers: [User] = []
    @State private var cancellables = Set<AnyCancellable>()
    @Binding var searchText: String
    
    let mode: SelectionMode
    
    var body: some View {
        List(filteredGroups, id: \.id) { group in
            rowView(for: group)
        }
        .listStyle(.plain)
        .onAppear {
            GatherlyAPI.getGroups()
                .receive(on: RunLoop.main)
                .sink { self.allGroups = $0 }
                .store(in: &cancellables)
            
            GatherlyAPI.getUsers()
                .receive(on: RunLoop.main)
                .sink { self.allUsers = $0 }
                .store(in: &cancellables)
        }
    }
}

private extension GroupsListView {
    
    //MARK: - Computed var
    
    var currentUser: User? {
            allUsers.first(where: { $0.id == 1 })
        }
    
    var filteredGroups: [UserGroup] {
        guard let currentUser else {
            return []
        }
        
        let userGroups = allGroups.filter { group in
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
    
    //MARK: - Subviews
    
    @ViewBuilder
    private func rowView(for group: UserGroup) -> some View {
        switch mode {
        case .view:
            NavigationLink(destination: GroupDetailView(group: group)) {
                GroupRow(group: group)
            }
            .accessibilityIdentifier("groupRow-\(group.name ?? "")")
            
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
