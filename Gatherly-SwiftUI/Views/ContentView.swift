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
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TabView(selection: $navigationState.selectedTab) {
            NavigationStack {
                CalendarView(
                    currentUser: viewModel.currentUser,
                    events: $viewModel.events,
                    users: viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(isPresented: viewModel.isLoading && navigationState.selectedTab == 0,
                                      message: Constants.ContentView.calendarViewLoadingString)
            }
            .tabItem {
                Image(systemName: "calendar")
            }
            .tag(0)
            
            NavigationStack {
                CreateEventView(
                    allUsers: viewModel.users,
                    currentUser: viewModel.currentUser,
                    events: $viewModel.events
                )
                .environmentObject(navigationState)
                .navigationTitle("Create Event")
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
            }
            .tag(1)
            
            NavigationStack {
                FriendsView(
                    currentUser: viewModel.currentUser,
                    groups: $viewModel.groups,
                    users: $viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(isPresented: viewModel.isLoading && navigationState.selectedTab == 2,
                                      message: Constants.ContentView.friendsViewLoadingString)
            }
            .tabItem {
                Image(systemName: "person.3.fill")
            }
            .tag(2)
            
            NavigationStack {
                ProfileView(
                    currentUser: viewModel.currentUser,
                    users: $viewModel.users
                )
                .environmentObject(navigationState)
                .addActivityIndicator(isPresented: viewModel.isLoading && navigationState.selectedTab == 3,
                                      message: Constants.ContentView.profileViewLoadingString)
            }
            .tabItem {
                Image(systemName: "person")
            }
            .tag(3)
            
        }
        .task {
            viewModel.loadAllData()
            viewModel.syncContacts()
        }
    }
}

#Preview {
    ContentView()
}
