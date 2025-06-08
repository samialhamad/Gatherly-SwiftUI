//
//  FriendsPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/18/25.
//

import SwiftUI

struct FriendsPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMemberIDs: Set<Int>
    
    @State private var searchText = ""
    @State private var selectedTab: FriendsTab = .friends
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FriendsView.pickerView(selectedTab: $selectedTab)
                SearchBarView(searchText: $searchText)
                
                switch selectedTab {
                case .friends:
                    FriendsListView(
                        searchText: $searchText,
                        mode: .select(selectedIDs: $selectedMemberIDs)
                    )
                case .groups:
                    GroupsListView(
                        searchText: $searchText,
                        mode: .select(selectedIDs: $selectedMemberIDs)
                    )
                }
            }
            .navigationTitle("Invite Members")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
