//
//  SearchableTabPickerView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/4/25.
//

import SwiftUI

struct SearchableTabPickerView<Content: View>: View {
    let tabTitles: [String]
    let users: [User]
    let groups: [UserGroup]
    let currentUser: User
    @ViewBuilder let tabContent: (_ selectedTab: Int, _ searchText: Binding<String>) -> Content

    @State private var selectedTab = 0
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
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

            SearchBarView(searchText: $searchText)
                .padding(.horizontal)

            tabContent(selectedTab, $searchText)
        }
    }
}
