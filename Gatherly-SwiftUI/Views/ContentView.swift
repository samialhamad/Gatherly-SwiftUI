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
    @StateObject private var eventsViewModel = EventsViewModel()
    @StateObject private var groupsViewModel = GroupsViewModel()
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var usersViewModel = UsersViewModel()
    
    private var isLoading: Bool {
        usersViewModel.isLoading || usersViewModel.currentUser == nil
    }
    
    var body: some View {
        Group {
            if isLoading {
                ActivityIndicator(message: Constants.ContentView.loadingString)
            } else {
                TabView(selection: $navigationState.selectedTab) {
                    calendarTab
                    createEventTab
                    friendsTab
                    profileTab
                }
                .environmentObject(eventsViewModel)
                .environmentObject(groupsViewModel)
                .environmentObject(usersViewModel)
            }
        }
        .task {
            AppInitializer.runIfNeeded()
            await ContactSyncHelper.runIfNeeded(currentUserID: SampleData.currentUserID)
            usersViewModel.loadIfNeeded() 
            eventsViewModel.loadIfNeeded()
            groupsViewModel.loadIfNeeded()
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
            EventFormView()
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
