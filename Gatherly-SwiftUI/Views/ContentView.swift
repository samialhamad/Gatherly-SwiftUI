//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navigationState = NavigationState()
    @State private var events: [Event] = SampleData.sampleEvents
    @State private var users: [User] = SampleData.sampleUsers
    
    var body: some View {
        TabView(selection: $navigationState.selectedTab) {
            NavigationStack {
                CalendarView(events: $events, users: users)
                    .environmentObject(navigationState)
                    .navigationTitle("My Events")
            }
            .tabItem {
                Label("My Events", systemImage: "calendar")
            }
            .tag(0)
            
            NavigationStack {
                CreateEventView(allUsers: users, events: $events)
                    .environmentObject(navigationState)
                    .navigationTitle("Create Event")
            }
            .tabItem {
                Label("Create", systemImage: "plus")
            }
            .tag(1)
            
            Text("Friends")
                .tabItem {
                    Label("Friends", systemImage: "heart")
                }
                .tag(2)
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
