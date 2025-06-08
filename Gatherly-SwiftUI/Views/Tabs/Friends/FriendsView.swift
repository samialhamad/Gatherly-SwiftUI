//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

enum FriendsTab: String, CaseIterable, Identifiable {
    case friends = "Friends"
    case groups = "Groups"
    var id: Self { self }
    var title: String { rawValue }
}

struct FriendsView: View {
    @State private var createFriendStore: Store<UserFormReducer.State, UserFormReducer.Action>? = nil
    @State private var isShowingCreateGroup = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var searchText = ""
    @State private var selectedTab: FriendsTab = .friends
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab)
                SearchBarView(searchText: $searchText)
                
                switch selectedTab {
                case .friends:
                    FriendsListView(searchText: $searchText, mode: .view)
                case .groups:
                    GroupsListView(searchText: $searchText, mode: .view)
                }
            }
            .accessibilityIdentifier("friendsViewRoot")
            .navigationTitle(selectedTab.title)
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
    
    // MARK: - Functions
    
    func dismissCreateFriendSheet() {
        createFriendStore = nil
    }
    
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
        GroupFormView(currentUserID: SampleData.currentUserID)
    }
    
    struct pickerView: View {
        @Binding var selectedTab: FriendsTab
        
        var body: some View {
            Picker("", selection: $selectedTab) {
                ForEach(FriendsTab.allCases, id: \.self) { tab in
                    Text(tab.title)
                        .tag(tab)
                        .accessibilityIdentifier("friendsTabSegment-\(tab.title)")
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
            switch selectedTab {
            case .friends:
                createFriendStore = Store(
                    initialState: UserFormReducer.State(
                        currentUser: User(),
                        firstName: "",
                        lastName: "",
                        avatarImageName: nil,
                        bannerImageName: nil,
                        avatarImage: nil,
                        bannerImage: nil,
                        mode: .createFriend
                    ),
                    reducer: { UserFormReducer() }
                )
            case .groups:
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
        dismissCreateFriendSheet()
    }
    
    func userFormViewDidUpdateUser(updatedUser: User) {
        usersViewModel.create(updatedUser) { createdFriend in
            guard let currentUser = usersViewModel.currentUser else {
                dismissCreateFriendSheet()
                return
            }
            
            if let newID = createdFriend.id, !(currentUser.friendIDs ?? []).contains(newID) {
                currentUser.friendIDs?.append(newID)
                currentUser.friendIDs = currentUser.friendIDs?.sorted()
                usersViewModel.update(currentUser)
            }
            
            dismissCreateFriendSheet()
        }
    }
}

#Preview {
    FriendsView()
}
