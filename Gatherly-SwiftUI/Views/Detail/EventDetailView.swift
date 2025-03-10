//
//  EventDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct EventDetailView: View {
    @Binding var events: [Event]
    let event: Event
    let users: [User]
    var onSave: ((Event) -> Void)? = nil
    
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) var dismiss
    @State private var isShowingEditView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            eventTitleView
            eventDescriptionView
            eventDateView
            eventTimeView
            eventPlannerAndMembersView
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
                viewModel: EditEventViewModel(event: event),
                allUsers: users,
                onSave: { updatedEvent in
                    onSave? (updatedEvent)
                    isShowingEditView = false
                },
                onCancel: {
                    isShowingEditView = false
                },
                onDelete: { eventToDelete in
                    let (updatedEvents, newSelectedDate) = EventEditor.deleteEvent(from: events, eventToDelete: eventToDelete)
                    events = updatedEvents
                    navigationState.calendarSelectedDate = newSelectedDate
                    navigationState.navigateToEvent = nil
                    isShowingEditView = false
                    dismiss()
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
                Text("Date: \(date.formatted(date: .long, time: .omitted))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventTimeView: some View {
        Group {
            if let startTimestamp = event.startTimestamp {
                let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
                Text("Start: \(startDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
            
            if let endTimestamp = event.endTimestamp {
                let endDate = Date(timeIntervalSince1970: TimeInterval(endTimestamp))
                Text("End: \(endDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventPlannerAndMembersView: some View {
        Group {
            if let planner = planner {
                Text("Planner: \(planner.firstName ?? "") \(planner.lastName ?? "")")
                    .font(.headline)
            }
            
            if !members.isEmpty {
                Text("Attendees:")
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
        // Filter out the planner's id from the memberIDs, so they dont show up in the attendee's section
        let filteredMemberIDs = memberIDs.filter { id in
            if let plannerID = event.plannerID, id == plannerID {
                return false
            }
            return true
        }
        
        return users.filter { user in
            if let userID = user.id {
                return filteredMemberIDs.contains(userID)
            }
            return false
        }
    }
}

#Preview {
    EventDetailView(
        events: .constant(SampleData.sampleEvents),
        event: SampleData.sampleEvents[1],
        users: SampleData.sampleUsers
    )
    .environmentObject(NavigationState())
}
