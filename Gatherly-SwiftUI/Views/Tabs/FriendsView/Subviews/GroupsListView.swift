//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct GroupsListView: View {
    @Binding var searchText: String
    
    var body: some View {
        List {
            ForEach(viewModel.filteredGroups, id: \.id) { group in
                NavigationLink(destination: GroupDetailView(group: group)) {
                    GroupRow(group: group)
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.searchText = searchText
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue
        }
    }
}
