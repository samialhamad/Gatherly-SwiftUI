//
//  FriendsPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/18/25.
//

import SwiftUI

struct FriendsPicker: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMemberIDs: Set<Int>
    
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    private let tabTitles = ["Friends", "Groups"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FriendsView.pickerView(selectedTab: $selectedTab, tabTitles: tabTitles)
                SearchBarView(searchText: $searchText)
                
                if selectedTab == 0 {
                    FriendsListView(
                        searchText: $searchText,
                        mode: .select(selectedIDs: $selectedMemberIDs)
                    )
                } else {
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
