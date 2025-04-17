//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsView: View {
    private let tabTitles = ["Friends", "Groups"]
    
    @Binding var groups: [UserGroup]
    @Binding var users: [User]
    @State private var isShowingAddFriend = false
    @State private var isShowingCreateGroup = false
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    var currentUser: User? {
        users.first(where: { $0.id == 1 })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    if let currentUser = currentUser {
                        FriendsListView(
                            searchText: $searchText,
                            currentUserID: currentUser.id ?? 1,
                            users: users
                        )
                    }
                } else {
                    GroupsListView(groups: $groups, searchText: $searchText)
                }
            }
            .navigationTitle(tabTitles[selectedTab])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButton
                }
            }
            .sheet(isPresented: $isShowingAddFriend) {
                if let currentUser = currentUser {
                    AddFriendView(viewModel: AddFriendViewModel(
                        currentUserID: currentUser.id ?? 1,
                        allUsers: users
                    ))
                }
            }
            .sheet(isPresented: $isShowingCreateGroup) {
                if let currentUser = currentUser {
                    CreateGroupView(currentUser: currentUser, groups: $groups)
                }
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
//#Preview {
//    FriendsView()
//        .environmentObject(NavigationState())
//}
