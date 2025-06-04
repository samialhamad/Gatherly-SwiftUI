//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct FriendsView: View {
    @State private var createFriendStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    @State private var isShowingCreateGroup = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var searchText = ""
    @State private var selectedTab = 0
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    private let tabTitles = ["Friends", "Groups"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(searchText: $searchText, mode: .view)
                } else {
                    GroupsListView(searchText: $searchText, mode:. view)
                }
            }
            .accessibilityIdentifier("friendsViewRoot")
            .navigationTitle(tabTitles[selectedTab])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButton
                }
            }
            .sheet(isPresented: Binding(
                get: { createFriendStore != nil },
                set: { newValue in
                    if !newValue {
                        createFriendStore = nil
                    }
                }
            )) {
                createFriendSheet
            }
            .sheet(isPresented: $isShowingCreateGroup) {
                createGroupSheet
            }
            .navigationDestination(isPresented: Binding(
                get: { navigationState.navigateToGroup != nil },
                set: { newValue in
                    if !newValue {
                        navigationState.navigateToGroup = nil
                    }
                }
            )) {
                if let groupID = navigationState.navigateToGroup?.id {
                    GroupDetailView(groupID: groupID)
                } else {
                    EmptyView()
                }
            }
        }
        .refreshOnAppear()
        .onAppear {
            usersViewModel.loadIfNeeded()
        }
        .keyboardDismissable()
    }
}

extension FriendsView {
    
    // MARK: - Subviews
    
    var createFriendSheet: some View {
        Group {
            if let store = createFriendStore {
                UserFormView(
                    store: store,
                    delegate: self
                )
            }
        }
    }
    
    var createGroupSheet: some View {
        CreateGroupView(currentUserID: 1)
    }
    
    struct pickerView: View {
        @Binding var selectedTab: Int
        let tabTitles: [String]
        
        var body: some View {
            Picker("", selection: $selectedTab) {
                ForEach(tabTitles.indices, id: \.self) { index in
                    Text(tabTitles[index])
                        .tag(index)
                        .accessibilityIdentifier("friendsTabSegment-\(tabTitles[index])")
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
                createFriendStore = Store(
                    initialState: UserFormFeature.State(
                        currentUser: User(),
                        firstName: "",
                        lastName: "",
                        avatarImageName: nil,
                        bannerImageName: nil,
                        avatarImage: nil,
                        bannerImage: nil,
                        isCreatingFriend: true
                    ),
                    reducer: { UserFormFeature() }
                )
            } else {
                isShowingCreateGroup = true
            }
        } label: {
            Image(systemName: "plus")
        }
        .labelStyle(.iconOnly)
        .accessibilityIdentifier("addFriendOrGroupButton")
    }
}

//MARK: - UserFormViewDelegate

extension FriendsView: UserFormViewDelegate {
    func userFormViewDidCancel() {
        createFriendStore = nil
    }
    
    func userFormViewDidUpdateUser(updatedUser: User) {
        usersViewModel.create(updatedUser) { createdFriend in
            guard var currentUser = usersViewModel.currentUser else {
                createFriendStore = nil
                return
            }

            if let newID = createdFriend.id, !(currentUser.friendIDs ?? []).contains(newID) {
                currentUser.friendIDs?.append(newID)
                currentUser.friendIDs = currentUser.friendIDs?.sorted()
                usersViewModel.update(currentUser)
            }

            createFriendStore = nil
        }
    }
}

#Preview {
    FriendsView()
}
