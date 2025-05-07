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
    
    let friendsDict: [Int: User]
    private let tabTitles = ["Friends", "Groups"]
    
    private var friends: [User] {
        currentUser.resolvedFriends(from: friendsDict)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(
                        searchText: $searchText,
                        currentUser: currentUser,
                        friends: friends
                    )
                } else {
                    GroupsListView(
                        currentUser: currentUser,
                        groups: $groups,
                        searchText: $searchText,
                        friendsDict: friendsDict
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
                addFriendSheet
            }
            .sheet(isPresented: $isShowingCreateGroup) {
                createGroupSheet
            }
        }
        .keyboardDismissable()
    }
}

private extension FriendsView {
    
    //MARK: - Subviews
    
    var addFriendSheet: some View {
        AddFriendView(
            currentUser: currentUser,
            viewModel: AddFriendViewModel(
                currentUserID: currentUser.id ?? 1,
                allUsers: friends
            )
        )
    }
    
    var createGroupSheet: some View {
        CreateGroupView(
            currentUser: currentUser,
            groups: $groups,
            friendsDict: friendsDict
        )
    }
    
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
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })

    return FriendsView(
        currentUser: currentUser,
        groups: .constant(SampleData.sampleGroups),
        friendsDict: friendsDict
    )
    .environmentObject(NavigationState())
}
