//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsView: View {
    let currentUser: User = SampleData.sampleUsers[0] // replace with actual logic
    private let tabTitles = ["Friends", "Groups"]
    
    @Binding var groups: [UserGroup]
    @State private var isShowingAddFriend = false
    @State private var isShowingCreateGroup = false
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(searchText: $searchText)
                } else {
                    GroupsListView(groups: $groups, searchText: $searchText)
                }
            }
            .navigationTitle(tabTitles[selectedTab])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
            .sheet(isPresented: $isShowingAddFriend) {
                AddFriendView(viewModel: AddFriendViewModel(
                    currentUser: currentUser,
                    allUsers: SampleData.sampleUsers
                ))
            }
            .sheet(isPresented: $isShowingCreateGroup) {
                CreateGroupView(currentUser: currentUser, groups: $groups)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

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

//#Preview {
//    FriendsView()
//        .environmentObject(NavigationState())
//}
