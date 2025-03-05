//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var events: [Event] = SampleData.sampleEvents
    @State private var users: [User] = SampleData.sampleUsers
    
    var body: some View {
        TabView {
            NavigationStack {
                CalendarView(events: $events, users: users)
                    .navigationTitle("My Events")
            }
            .tabItem {
                Label("My Events", systemImage: "calendar")
            }
            
            NavigationStack {
                CreateEventView(events: $events, allUsers: users)
                    .navigationTitle("Create Event")
            }
            .tabItem {
                Label("Create", systemImage: "plus")
            }
            
            Text("Friends")
                .tabItem {
                    Label("Friends", systemImage: "heart")
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
