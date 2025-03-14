//
//  EventFormSections.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/6/25.
//

import SwiftUI

struct EventDetailsSection: View {
    let header: String
    @Binding var title: String
    @Binding var description: String
    
    var body: some View {
        Section(header: Text(header)) {
            TextField("Title", text: $title)
            TextField("Description", text: $description, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
        }
    }
}

struct EventDateTimeSection: View {
    let header: String
    let eventDate: Binding<Date>
    let startTime: Binding<Date>
    let endTime: Binding<Date>
    
    let startTimeRange: ClosedRange<Date>
    let endTimeRange: ClosedRange<Date>
    
    var body: some View {
        Section(header: Text(header)) {
            DatePicker("Event Date", selection: eventDate, in: Date()..., displayedComponents: .date)
            DatePicker("Start Time", selection: startTime, in: startTimeRange, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: endTime, in: endTimeRange, displayedComponents: .hourAndMinute)
        }
    }
}

struct EventMembersSection: View {
    let header: String
    let allUsers: [User]
    let selectedMemberIDs: Binding<Set<Int>>
    let plannerID: Int?
    
    var body: some View {
        Section(header: Text(header)) {
            ForEach(filteredUsers, id: \.id) { user in
                Toggle("\(user.firstName ?? "") \(user.lastName ?? "")",
                       isOn: Binding(
                        get: { selectedMemberIDs.wrappedValue.contains(user.id ?? -1) },
                        set: { newValue in
                            if newValue {
                                selectedMemberIDs.wrappedValue.insert(user.id ?? -1)
                            } else {
                                selectedMemberIDs.wrappedValue.remove(user.id ?? -1)
                            }
                        }
                       )
                )
            }
        }
    }
    
    private var filteredUsers: [User] {
        allUsers.filter { user in
            if let id = user.id, let plannerID = plannerID {
                return id != plannerID
            }
            return true
        }
    }
}

struct EventLocationSection: View {
    let header: String
    @Binding var locationName: String
    // When a location is selected, pass the Location back.
    let onSetLocation: (Location?) -> Void
    
    @StateObject private var searchVM = LocationSearchViewModel()
    
    var body: some View {
        Section(header: Text(header)) {
            TextField("Enter location name", text: $locationName)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .onChange(of: locationName) { newValue in
                    searchVM.queryFragment = newValue
                }
            
            if !searchVM.suggestions.isEmpty {
                List(searchVM.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        searchVM.search(for: suggestion) { location in
                            onSetLocation(location)
                            // Optionally update the text field with the chosen location name:
                            if let name = location?.name {
                                locationName = name
                            }
                            // Clear suggestions after selection.
                            searchVM.suggestions = []
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                                .font(.body)
                            Text(suggestion.subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxHeight: 150)
            }
        }
    }
}

struct EventRowLink: View {
    @Binding var events: [Event]
    let event: Event
    let users: [User]
    let onSave: (Event) -> Void

    var body: some View {
        NavigationLink {
            EventDetailView(
                events: $events,
                event: event,
                users: users,
                onSave: onSave
            )
        } label: {
            EventRow(event: event)
        }
    }
}
