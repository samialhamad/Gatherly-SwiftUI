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
    @State private var groups: [UserGroup] = SampleData.sampleGroups
    @State private var users: [User] = SampleData.sampleUsers
    
    var body: some View {
        TabView(selection: $navigationState.selectedTab) {
            NavigationStack {
                CalendarView(events: $events, users: users)
                    .environmentObject(navigationState)
            }
            .tabItem {
                Image(systemName: "calendar")
            }
            .tag(0)
            
            NavigationStack {
                CreateEventView(allUsers: users, events: $events)
                    .environmentObject(navigationState)
                    .navigationTitle("Create Event")
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
            }
            .tag(1)
            
            NavigationStack {
                FriendsView(groups: $groups, users: $users)
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
            ContactSyncManager.shared.fetchContacts { contacts in
                let existingPhones = Set(users.compactMap { $0.phone?.filter(\.isWholeNumber) })
                let newUsers: [User] = contacts.enumerated().compactMap { index, contact in
                    let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
                    guard !existingPhones.contains(cleaned) else { return nil }
                    return User(from: contact, id: 1000 + index) // unique test IDs
                }
                
                users.append(contentsOf: newUsers)
            }
        }
    }
}

#Preview {
    ContentView()
}
