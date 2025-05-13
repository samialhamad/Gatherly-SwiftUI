//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        Group {
            if let currentUser = session.currentUser {
                TabView(selection: $session.navigationState.selectedTab) {
                    calendarTab
                    createEventTab
                    friendsTab
                    profileTab
                }
            } else {
                Text("No current user loaded").onAppear {
                    print("currentUser is nil in ContentView")
                }
            }
        }
        .task {
            session.loadAllData()
            session.syncContacts()
        }
    }
}

private extension ContentView {
    
    // MARK: - Tabs
    
    var calendarTab: some View {
        CalendarView()
        .environmentObject(session)
        .addActivityIndicator(
            isPresented: session.isLoading && session.navigationState.selectedTab == 0,
            message: Constants.ContentView.calendarViewLoadingString
        )
        .tabItem { Image(systemName: "calendar") }
        .tag(0)
    }
    
    var createEventTab: some View {
        NavigationStack {
            CreateEventView()
            .environmentObject(session)
            .navigationTitle("Create Event")
        }
        .tabItem { Image(systemName: "plus.app.fill") }
        .tag(1)
    }
    
    var friendsTab: some View {
        NavigationStack {
            FriendsView()
            .environmentObject(session)
            .addActivityIndicator(
                isPresented: session.isLoading && session.navigationState.selectedTab == 2,
                message: Constants.ContentView.friendsViewLoadingString
            )
        }
        .tabItem { Image(systemName: "person.3.fill") }
        .tag(2)
    }
    
    var profileTab: some View {
        NavigationStack {
            ProfileView()
            .environmentObject(session)
            .addActivityIndicator(
                isPresented: session.isLoading && session.navigationState.selectedTab == 3,
                message: Constants.ContentView.profileViewLoadingString
            )
        }
        .tabItem { Image(systemName: "person") }
        .tag(3)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSession())
}
