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
    @State private var isLoading = true
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        Group {
            if let currentUser {
                TabView(selection: $navigationState.selectedTab) {
                    calendarTab
                    createEventTab
                    friendsTab
                    profileTab
                }
            } else if isLoading {
                ActivityIndicator(message: Constants.ContentView.loadingString)
            }
        }
        .task {
            AppInitializer.runIfNeeded()
            ContactSyncHelper.runIfNeeded(currentUserID: 1)
            
            GatherlyAPI.getUsers()
                .receive(on: RunLoop.main)
                .sink { users in
                    currentUser = users.first(where: { $0.id == 1 })
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
            .tag(0)
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
        .tag(1)
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
        .tag(2)
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
        .tag(3)
    }
}

#Preview {
    ContentView()
}
