//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var navigationState = NavigationState()
    @State private var selectedIndex = 0
    @StateObject private var viewModel = ContentViewModel()
    
    var currentUser: User? {
        viewModel.currentUser
    }
    
    var body: some View {
        Group {
            if let currentUser {
                VStack() {
                    tabContentView(
                        for: selectedIndex,
                        currentUser: currentUser
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    TabBarView(selectedIndex: $selectedIndex)
                }
                .edgesIgnoringSafeArea(.bottom)
            } else {
                Text("No current user loaded").onAppear {
                    print("currentUser is nil in ContentView")
                }
            }
        }
        .task {
            viewModel.loadAllData()
            viewModel.syncContacts()
        }
    }
}

private extension ContentView {
    @ViewBuilder
    func tabContentView(for index: Int, currentUser: User) -> some View {
        switch index {
        case 0:
            NavigationStack {
                CalendarView(
                    currentUser: currentUser,
                    events: $viewModel.events,
                    users: viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(
                    isPresented: viewModel.isLoading && selectedIndex == 0,
                    message: Constants.ContentView.calendarViewLoadingString
                )
            }
        case 1:
            NavigationStack {
                CreateEventView(
                    currentUser: currentUser,
                    events: $viewModel.events,
                    allUsers: viewModel.users
                )
                .environmentObject(navigationState)
                .navigationTitle("Create Event")
            }
        case 2:
            NavigationStack {
                FriendsView(
                    currentUser: currentUser,
                    groups: $viewModel.groups,
                    users: $viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(
                    isPresented: viewModel.isLoading && selectedIndex == 2,
                    message: Constants.ContentView.friendsViewLoadingString
                )
            }
        case 3:
            NavigationStack {
                ProfileView(
                    currentUser: currentUser,
                    users: $viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(
                    isPresented: viewModel.isLoading && selectedIndex == 3,
                    message: Constants.ContentView.profileViewLoadingString
                )
            }
        default:
            EmptyView()
        }
    }
}


#Preview {
    ContentView()
}
