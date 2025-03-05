//
//  ContentView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CalendarView(events: SampleData.sampleEvents, users: SampleData.sampleUsers)
                    .navigationTitle("My Events")
            }
            .tabItem {
                Label("My Events", systemImage: "calendar")
            }
            
            Text("Create Event")
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
