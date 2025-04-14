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
                CalendarView(events: $viewModel.events, users: viewModel.users)
                    .environmentObject(navigationState)
            }
            .tabItem {
                Image(systemName: "calendar")
            }
            .tag(0)
            
            NavigationStack {
                CreateEventView(allUsers: viewModel.users, events: $viewModel.events)
                    .environmentObject(navigationState)
                    .navigationTitle("Create Event")
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
            }
            .tag(1)
            
            NavigationStack {
                FriendsView(groups: $viewModel.groups, users: $viewModel.users)
                    .environmentObject(navigationState)
            }
            .tabItem {
                Image(systemName: "person.3.fill")
            }
            .tag(2)
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
        .task {
            viewModel.loadAllData()
        }
    }
}

#Preview {
    ContentView()
}
