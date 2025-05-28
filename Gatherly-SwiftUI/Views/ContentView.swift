//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Combine
import SwiftUI

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var currentUser: User? = nil
    @StateObject private var eventsViewModel = EventsViewModel()
    @StateObject private var groupsViewModel = GroupsViewModel()
    @State private var isLoading = true
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var usersViewModel = UsersViewModel()
    
    var body: some View {
        Group {
            if let currentUser {
                TabView(selection: $navigationState.selectedTab) {
                    calendarTab
                    createEventTab
                    friendsTab
                    profileTab
                }
                .environmentObject(eventsViewModel)
                .environmentObject(groupsViewModel)
                .environmentObject(usersViewModel)
            } else if isLoading {
                ActivityIndicator(message: Constants.ContentView.loadingString)
            }
        }
        .task {
            AppInitializer.runIfNeeded()
            ContactSyncHelper.runIfNeeded(currentUserID: 1)
            
            GatherlyAPI.getUser()
                .receive(on: RunLoop.main)
                .sink { user in
                    currentUser = user
                    isLoading = false
                }
                .store(in: &cancellables)
        }
    }
}

private extension ContentView {
    
    // MARK: - Tabs
    
    var calendarTab: some View {
        CalendarView()
            .tabItem {
                Label("Calendar", systemImage: "calendar")
                    .labelStyle(.iconOnly)
            }
            .accessibilityIdentifier("calendarTab")
            .tag(Tab.calendar.rawValue)
    }
    
    var createEventTab: some View {
        NavigationStack {
            CreateEventView()
                .navigationTitle("Create Event")
        }
        .tabItem {
            Label("Create", systemImage: "plus.app.fill")
                .labelStyle(.iconOnly)
        }
        .accessibilityIdentifier("createEventTab")
        .tag(Tab.create.rawValue)
    }
    
    var friendsTab: some View {
        NavigationStack {
            FriendsView()
        }
        .tabItem {
            Label("Friends", systemImage: "person.3.fill")
                .labelStyle(.iconOnly)
        }
        .accessibilityIdentifier("friendsTab")
        .tag(Tab.friends.rawValue)
    }
    
    var profileTab: some View {
        NavigationStack {
            ProfileView()
        }
        .tabItem {
            Label("Profile", systemImage: "person")
                .labelStyle(.iconOnly)
        }
        .accessibilityIdentifier("profileTab")
        .tag(Tab.profile.rawValue)
    }
}

#Preview {
    ContentView()
}
