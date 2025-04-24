//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsView: View {
    @ObservedObject var currentUser: User
    @Binding var groups: [UserGroup]
    @State private var isShowingAddFriend = false
    @State private var isShowingCreateGroup = false
    @State private var searchText = ""
    @State private var selectedTab = 0
    @Binding var users: [User]
    
    private let tabTitles = ["Friends", "Groups"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                        FriendsListView(
                            searchText: $searchText,
                            currentUserID: currentUser.id ?? 1,
                            users: users
                        )
                } else {
                        GroupsListView(
                            currentUser: currentUser,
                            groups: $groups,
                            searchText: $searchText,
                            users: users
                        )
                }
            }
            .navigationTitle(tabTitles[selectedTab])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButton
                }
            }
            .sheet(isPresented: $isShowingAddFriend) {
                    AddFriendView(
                        currentUser: currentUser,
                        viewModel: AddFriendViewModel(
                            currentUserID: currentUser.id ?? 1,
                            allUsers: users
                        )
                    )
            }
            .sheet(isPresented: $isShowingCreateGroup) {
                    CreateGroupView(
                        currentUser: currentUser,
                        users: users,
                        groups: $groups
                    )
            }
        }
        .keyboardDismissable()
    }
}

private extension FriendsView {
    
    //MARK: - Subviews
    
    struct pickerView: View {
        @Binding var selectedTab: Int
        let tabTitles: [String]
        
        var body: some View {
            Picker("", selection: $selectedTab) {
                ForEach(tabTitles.indices, id: \.self) { index in
                    Text(tabTitles[index])
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, Constants.FriendsView.pickerViewVerticalPadding)
            .background(Color(Colors.primary))
        }
    }
    
    var toolbarButton: some View {
        Button {
            if selectedTab == 0 {
                isShowingAddFriend = true
            } else {
                isShowingCreateGroup = true
            }
        } label: {
            Image(systemName: "plus")
        }
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        FriendsView(
            currentUser: sampleUser,
            groups: .constant(SampleData.sampleGroups),
            users: .constant(SampleData.sampleUsers)
        )
        .environmentObject(NavigationState())
    }
}
