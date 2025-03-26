//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsView: View {
    private let tabTitles = ["Friends", "Groups"]
    
    @State private var isShowingAddFriend = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("SubTabs", selection: $selectedTab) {
                    ForEach(0..<tabTitles.count, id: \.self) { index in
                        Text(tabTitles[index])
                            .tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedTab) {
                    FriendsListView()
                        .tag(0)
                    GroupsView()
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddFriend.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddFriend) {
                AddFriendView()
            }
        }
    }
}

struct GroupsView: View {
    var body: some View {
        Text("Groups")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
    }
}

struct AddFriendView: View {
    var body: some View {
        Text("Add Friends")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    FriendsView()
        .environmentObject(NavigationState())
}
