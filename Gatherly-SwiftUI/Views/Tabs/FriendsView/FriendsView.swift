//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import ComposableArchitecture
import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var session: AppSession
    @State private var createFriendStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    @State private var isShowingCreateGroup = false
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    private let tabTitles = ["Friends", "Groups"]
    
    private var currentUser: User? {
        session.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(searchText: $searchText)
                } else {
                    GroupsListView(searchText: $searchText)
                }
            }
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
        }
        .refreshOnAppear()
        .keyboardDismissable()
    }
}

private extension FriendsView {
    
    //MARK: - Functions
    
    func handleCreateFriendComplete(_ action: UserFormFeature.Action) {
        guard let currentUserID = currentUser?.id else {
            return
        }
        
        switch action {
        case .cancel:
            break
        case .delegate(let delegateAction):
            if case let .didSave(newFriend) = delegateAction {
                session.appendUsersAndUpdateFriends(
                    newUsers: [newFriend],
                    newFriendIDs: [newFriend.id ?? 0],
                    currentUserID: currentUserID
                )
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
        CreateGroupView(currentUserID: session.currentUser?.id ?? 1)
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
    }
}

#Preview {
    FriendsView()
        .environmentObject(AppSession())
}
