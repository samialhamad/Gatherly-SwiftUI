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
    var onSave: ((Event) -> Void)? = nil
    
    @State private var isShowingEditView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            eventTitleView
            eventDescriptionView
            eventDateView
            eventTimeView
            eventLeaderAndMembersView
            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isShowingEditView = true
                }
                
                .disabled(event.hasStarted || event.hasEnded)
            }
        }
        
        .sheet(isPresented: $isShowingEditView) {
            EditEventView(
                event: event,
                allUsers: users,
                onSave: { updatedEvent in
                    isShowingEditView = false
                },
                onCancel: {
                    isShowingEditView = false
                }
            )
        }
    }
}

// MARK: - Subviews

private extension EventDetailView {
    var eventTitleView: some View {
        Text(event.title ?? "Untitled Event")
            .font(.title)
            .bold()
    }
    
    var eventDescriptionView: some View {
        Group {
            if let description = event.description {
                Text(description)
                    .font(.body)
            }
        }
    }
    
    var eventDateView: some View {
        Group {
            if let date = event.date {
                // Show only the day (e.g., "March 5, 2025")
                Text("Date: \(date.formatted(date: .long, time: .omitted))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventTimeView: some View {
        Group {
            // Start time
            if let startTimestamp = event.startTimestamp {
                let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
                Text("Start: \(startDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
            
            // End time
            if let endTimestamp = event.endTimestamp {
                let endDate = Date(timeIntervalSince1970: TimeInterval(endTimestamp))
                Text("End: \(endDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventLeaderAndMembersView: some View {
        Group {
            if let planner = planner {
                Text("Leader: \(planner.firstName ?? "") \(planner.lastName ?? "")")
                    .font(.headline)
            }
            
            if !members.isEmpty {
                Text("Members:")
                    .font(.headline)
                ForEach(members, id: \.id) { user in
                    Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                }
            }
        }
    }
}

// MARK: - Computed Vars

private extension EventDetailView {
    var planner: User? {
        guard let plannerID = event.plannerID else {
            return nil
        }
        
        return users.first(where: { $0.id == plannerID })
    }
    
    var members: [User] {
        guard let memberIDs = event.memberIDs else {
            return []
        }
        
        return users.filter { memberIDs.contains($0.id ?? 0) }
    }
}

#Preview {
    EventDetailView(event: SampleData.sampleEvents[1], users: SampleData.sampleUsers)
}
