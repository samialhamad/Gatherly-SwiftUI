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
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                searchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(searchText: $searchText)
                } else {
                    GroupsView()
                }
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

struct searchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
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
