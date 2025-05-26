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
                if let group = navigationState.navigateToGroup {
                    GroupDetailView(group: group)
                } else {
                    EmptyView()
                }
            }
        }
        .refreshOnAppear()
        .keyboardDismissable()
    }
}

extension FriendsView {
    
    //MARK: - Functions
    
    func handleCreateFriendComplete(_ action: UserFormFeature.Action) {
        let currentUserID = 1
        
        switch action {
        case .cancel:
            break
        case .delegate(let delegateAction):
            if case let .didSave(newFriend) = delegateAction {
                _ = GatherlyAPI.createUser(newFriend)
                    .flatMap { createdUser -> AnyPublisher<(User, [User]), Never> in
                        GatherlyAPI.getUser()
                            .combineLatest(GatherlyAPI.getUsers())
                            .map { user, users in
                                let users = ([user].compactMap { $0 }) + users
                                return (createdUser, users)
                            }
                            .eraseToAnyPublisher()
                    }
                    .sink { result in
                        let (createdUser, users) = result
                        
                        var updatedUsers = users
                        
                        if let index = updatedUsers.firstIndex(where: { $0.id == 1 }) {
                            var currentUser = updatedUsers[index]
                            var ids = currentUser.friendIDs ?? []
                            
                            if let newID = createdUser.id, !ids.contains(newID) {
                                ids.append(newID)
                                currentUser.friendIDs = ids
                                updatedUsers[index] = currentUser
                            }
                            
                            UserDefaultsManager.saveUsers(updatedUsers)
                        }
                    }
            }
        default:
            break
        }
        
        createFriendStore = nil
    }
    
    //MARK: - Subviews
    
    var createFriendSheet: some View {
        Group {
            if let store = createFriendStore {
                UserFormView(
                    store: store,
                    onComplete: handleCreateFriendComplete
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

#Preview {
    FriendsView()
}
