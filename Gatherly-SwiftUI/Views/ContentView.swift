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
    
    var currentUser: User? {
        viewModel.currentUser
    }
    
    var body: some View {
        Group {
            if let currentUser {
                TabView(selection: $navigationState.selectedTab) {
                    calendarTab(for: currentUser)
                    createEventTab(for: currentUser)
                    friendsTab(for: currentUser)
                    profileTab(for: currentUser)
                }
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
    
    func calendarTab(for user: User) -> some View {
        CalendarView(
            currentUser: user,
            events: $viewModel.events,
            users: viewModel.users
        )
        .environmentObject(navigationState)
        .addActivityIndicator(
            isPresented: viewModel.isLoading && navigationState.selectedTab == 0,
            message: Constants.ContentView.calendarViewLoadingString
        )
        .tabItem { Image(systemName: "calendar") }
        .tag(0)
    }
    
    func createEventTab(for user: User) -> some View {
        NavigationStack {
            CreateEventView(
                currentUser: user,
                events: $viewModel.events,
                allUsers: viewModel.users
            )
            .environmentObject(navigationState)
            .navigationTitle("Create Event")
        }
        .tabItem { Image(systemName: "plus.app.fill") }
        .tag(1)
    }
    
    func friendsTab(for user: User) -> some View {
        NavigationStack {
            FriendsView(
                currentUser: user,
                groups: $viewModel.groups,
                users: $viewModel.users
            )
            .environmentObject(navigationState)
            .addActivityIndicator(
                isPresented: viewModel.isLoading && navigationState.selectedTab == 2,
                message: Constants.ContentView.friendsViewLoadingString
            )
        }
        .tabItem { Image(systemName: "person.3.fill") }
        .tag(2)
    }
    
    func profileTab(for user: User) -> some View {
        NavigationStack {
            ProfileView(
                currentUser: user,
                users: $viewModel.users
            )
            .environmentObject(navigationState)
            .addActivityIndicator(
                isPresented: viewModel.isLoading && navigationState.selectedTab == 3,
                message: Constants.ContentView.profileViewLoadingString
            )
        }
        .tabItem { Image(systemName: "person") }
        .tag(3)
    }
}

#Preview {
    ContentView()
}
