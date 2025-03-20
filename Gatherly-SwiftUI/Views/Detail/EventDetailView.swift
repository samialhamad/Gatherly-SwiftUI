//
//  EventDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    @Binding var events: [Event]
    let event: Event
    let users: [User]
    var onSave: ((Event) -> Void)? = nil
    
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) var dismiss
    @State private var isShowingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.EventDetailView.bodyVStackSpacing) {
                eventDescriptionView
                eventDateView
                eventTimeView
                Divider()
                eventMapPreview
                Divider()
                eventPlannerAndMembersView
                Divider()
                eventCategoriesView
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(event.title ?? "Untitled Event")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isShowingEditView = true
                }
                
                .disabled(event.hasStarted || event.hasEnded)
            }
        }
        .toolbarRole(.editor)
        
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
    
    //No longer being used, but keeping around for future just in case
    var eventTitleView: some View {
        Text(event.title ?? "Untitled Event")
            .font(.title)
            .bold()
            .centerText()
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
            if let startTimestamp = event.startTimestamp, let endTimestamp = event.endTimestamp {
                let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
                let endDate = Date(timeIntervalSince1970: TimeInterval(endTimestamp))
                
                Text("Time: \(startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var eventMapPreview: some View {
        Group {
            if let location = event.location {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                let annotation = LocationAnnotation(coordinate: coordinate, name: location.name)
                
                // older Map initializer with annotationItems - is deprecated in iOS 17
                Map(coordinateRegion: .constant(region), annotationItems: [annotation]) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack(spacing: Constants.EventDetailView.eventMapPreviewVStackSpacing) {
                            if let name = location.name, !name.isEmpty {
                                Text(name)
                                    .font(.caption)
                                    .padding(Constants.EventDetailView.eventMapPreviewTextPadding)
                                    .background(Color.white)
                                    .cornerRadius(Constants.EventDetailView.eventMapPreviewCornerRadius)
                                    .shadow(radius: Constants.EventDetailView.eventMapPreviewShadow)
                            }
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: Constants.EventDetailView.eventMapPreviewFrame)
                .cornerRadius(Constants.EventDetailView.eventMapPreviewCornerRadius)
            } else {
                Text("No Location Selected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .centerText()
                    .padding()
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
                Text("Attendees")
                    .font(.headline)
                ForEach(members, id: \.id) { user in
                    Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                }
            }
        }
    }
    
    var eventCategoriesView: some View {
        Group {
            if event.categories.isEmpty {
                Text("No categories assigned.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("\(event.categories.map { $0.rawValue }.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
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
