//
//  EventDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    let users: [User]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.title ?? "Untitled Event")
                .font(.title)
                .bold()
            
            if let description = event.description {
                Text(description)
                    .font(.body)
            }
            
            if let date = event.date {
                Text("Date: \(date.formatted(date: .long, time: .shortened))")
                    .foregroundColor(.secondary)
            }
            
            if let leader = leader {
                Text("Leader: \(leader.firstName ?? "") \(leader.lastName ?? "")")
                    .font(.headline)
            }
            
            if !members.isEmpty {
                Text("Members:")
                    .font(.headline)
                ForEach(members, id: \.id) { user in
                    Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension EventDetailView {
    var leader: User? {
        guard let leaderID = event.leaderID else { return nil }
        return users.first(where: { $0.id == leaderID })
    }

    var members: [User] {
        guard let memberIDs = event.memberIDs else { return [] }
        return users.filter { memberIDs.contains($0.id ?? 0) }
    }
}
