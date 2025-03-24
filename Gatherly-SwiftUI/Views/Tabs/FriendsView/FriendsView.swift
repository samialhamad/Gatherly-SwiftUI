//
//  FriendsView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsView: View {
    @State private var selectedTab = 0
    private let tabTitles = ["Friends", "Groups", "Add"]

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
                    AddFriendView()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Friends")
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
