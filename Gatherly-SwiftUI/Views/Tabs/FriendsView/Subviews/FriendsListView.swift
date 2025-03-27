//
//  FriendsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct FriendsListView: View {
    @Binding var searchText: String
    @StateObject private var viewModel = FriendsListViewModel()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ScrollViewReader { proxy in
                List {
                    ForEach(viewModel.sortedSectionKeys, id: \.self) { key in
                        Section(header: Text(key).id(key)) {
                            ForEach(viewModel.groupedFriends[key]?.sorted { ($0.firstName ?? "") < ($1.firstName ?? "") } ?? [], id: \.id) { friend in
                                NavigationLink(destination: ProfileDetailView(user: friend)) {
                                    ProfileRow(user: friend)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .overlay(
                    Group {
                        if viewModel.searchText.isEmpty {
                            AlphabetIndexView(letters: viewModel.sortedSectionKeys) { letter in
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }
                            .padding(.trailing, Constants.FriendsListView.overlayTrailingPadding)
                        }
                    },
                    alignment: .trailing
                )
                .onAppear {
                    viewModel.searchText = searchText
                }
                .onChange(of: searchText) { newValue in
                    viewModel.searchText = newValue
                }
            }
        }
    }
}
