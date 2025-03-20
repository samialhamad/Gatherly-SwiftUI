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
    @FocusState private var isDescriptionFocused: Bool
    
    var body: some View {
        Section(header: Text(header)) {
            TextField("Title", text: $title)
            
            HStack {
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .tint(.primary)
                    .focused($isDescriptionFocused)
                
                if isDescriptionFocused {
                    ClearButton(text: $description)
                }
            }
            
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
                .tint(Color(Brand.Colors.primary))
            
            DatePicker("Start Time", selection: startTime, in: startTimeRange, displayedComponents: .hourAndMinute)
                .tint(Color(Brand.Colors.primary))
            
            DatePicker("End Time", selection: endTime, in: endTimeRange, displayedComponents: .hourAndMinute)
                .tint(Color(Brand.Colors.primary))
        }
    }
}

struct EventMembersSection: View {
    let header: String
    let allUsers: [User]
    let plannerID: Int?
    
    @Binding var selectedMemberIDs: Set<Int>
    @State private var isMembersPickerPresented = false
    
    var body: some View {
        Section(header: Text(header)) {
            Button(action: {
                isMembersPickerPresented.toggle()
            }) {
                HStack {
                    Text("Invite Members")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(selectedMemberIDs.count) selected")
                        .foregroundColor(.secondary)
                }
                .addDisclosureIcon()
            }
            .sheet(isPresented: $isMembersPickerPresented) {
                EventMembersPicker(
                    allUsers: filteredUsers,
                    selectedMemberIDs: $selectedMemberIDs
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
            HStack {
                TextField("Enter location name", text: $locationName)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onChange(of: locationName) { newValue in
                        searchVM.queryFragment = newValue
                        
                        //check if a user clears the location, if so location is now nil (editing bug fix)
                        if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSetLocation(nil)
                        }
                    }
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
                                .foregroundColor(.primary)
                            
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

struct EventCategorySection: View {
    let header: String
    @Binding var selectedCategories: [Brand.EventCategory]
    @State private var isCategoryPickerPresented = false
    
    var body: some View {
        Section(header: Text(header)) {
            Button(action: {
                isCategoryPickerPresented.toggle()
            }) {
                HStack {
                    Text(selectedCategories.isEmpty ? "Select Categories" : selectedCategories.map { $0.rawValue }.joined(separator: ", "))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .addDisclosureIcon()
                .padding(.vertical, 8)
            }
            .sheet(isPresented: $isCategoryPickerPresented) {
                EventCategoryPicker(selectedCategories: $selectedCategories)
            }
        }
    }
}

struct EventRowLink: View {
    @Binding var events: [Event]
    let event: Event
    let users: [User]
    let onSave: (Event) -> Void
    var showDisclosure: Bool
    
    var body: some View {
        NavigationLink {
            EventDetailView(
                events: $events,
                event: event,
                users: users,
                onSave: onSave
            )
        } label: {
            EventRow(event: event, showDisclosure: showDisclosure)
        }
    }
}
