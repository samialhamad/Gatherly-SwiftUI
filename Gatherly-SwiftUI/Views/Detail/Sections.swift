//
//  Sections.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/6/25.
//

import Combine
import SwiftUI

struct EventDetailsSection: View {
    let header: String
    @Binding var title: String
    @Binding var description: String
    @FocusState private var isDescriptionFocused: Bool
    
    var body: some View {
        Section(header: Text(header)) {
            TextField("Title", text: $title)
                .accessibilityIdentifier("eventTitleTextField")
            
            HStack(alignment: .top) {
                TextField("Description", text: $description, axis: .vertical)
                    .accessibilityIdentifier("eventDescriptionTextField")
                    .lineLimit(3, reservesSpace: true)
                    .tint(Color(Colors.primary))
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
                .accessibilityIdentifier("eventDatePicker")
            
            DatePicker("Start Time", selection: startTime, in: startTimeRange, displayedComponents: .hourAndMinute)
                .accessibilityIdentifier("startTimePicker")
            
            DatePicker("End Time", selection: endTime, in: endTimeRange, displayedComponents: .hourAndMinute)
                .accessibilityIdentifier("endTimePicker")
        }
        .tint(Color(Colors.primary))
    }
}

public struct EventMembersSection: View {
    @State var cancellables = Set<AnyCancellable>()
    @State var friends: [User] = []
    @State var isMembersPickerPresented = false
    @Binding var selectedMemberIDs: Set<Int>
    
    let header: String
        
    public var body: some View {
        Section(header: Text(header)) {
            Button(action: {
                isMembersPickerPresented.toggle()
            }) {
                HStack {
                    Text("Invite Friends")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(selectedMemberIDs.count) selected")
                        .foregroundColor(.secondary)
                }
                .addDisclosureIcon()
            }
            .accessibilityIdentifier("inviteFriendsButton")
            .sheet(isPresented: $isMembersPickerPresented) {
                FriendsPicker(selectedMemberIDs: $selectedMemberIDs)
            }
        }
        .onAppear {
            Publishers.CombineLatest(GatherlyAPI.getCurrentUser(), GatherlyAPI.getUsers())
                .receive(on: RunLoop.main)
                .sink { user, friendsList in
                    if let user {
                        let friendsDict = friendsList.keyedBy(\.id)
                        
                        self.friends = user
                            .friends(from: friendsDict)
                            .filter { $0.id != SampleData.currentUserID }
                    }
                }
                .store(in: &cancellables)
        }
    }
}

struct EventLocationSection: View {
    let header: String
    @Binding var locationName: String
    let onSetLocation: (Location?) -> Void
    
    @State private var isSelectingSuggestion = false
    @State private var selectedLocationAddress: String = ""
    @StateObject private var searchViewModel = LocationSearchViewModel()
    
    var body: some View {
        Section(header: Text(header)) {
            HStack {
                TextField("Enter location name", text: $locationName)
                    .accessibilityIdentifier("eventLocationTextField")
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onChange(of: locationName) { _, newValue in
                        guard !isSelectingSuggestion else {
                            isSelectingSuggestion = false
                            return
                        }
                        
                        searchViewModel.queryFragment = newValue
                        
                        //check if a user clears the location, if so location is now nil (editing bug fix)
                        if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSetLocation(nil)
                        }
                    }
            }
            
            if !selectedLocationAddress.isEmpty {
                Text(selectedLocationAddress)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !searchViewModel.suggestions.isEmpty {
                List(searchViewModel.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        isSelectingSuggestion = true
                        searchViewModel.search(for: suggestion) { location in
                            onSetLocation(location)
                            
                            if let name = location?.name {
                                locationName = name
                            }
                            
                            selectedLocationAddress = location?.address ?? ""
                            searchViewModel.suggestions = []
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
                .frame(maxHeight: Constants.EventLocationSection.frameMaxHeight)
            }
        }
    }
}

struct EventCategorySection: View {
    let header: String
    @Binding var selectedCategories: [EventCategory]
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
                .padding(.vertical, Constants.EventCategorySection.verticalPadding)
            }
            .accessibilityIdentifier("categoryPickerButton")
            .sheet(isPresented: $isCategoryPickerPresented) {
                EventCategoryPicker(selectedCategories: $selectedCategories)
            }
        }
    }
}

struct EventRowLink: View {
    let event: Event
    var showDisclosure: Bool = true
    
    var body: some View {
        NavigationLink {
            EventDetailView(event: event)
        } label: {
            EventRow(event: event, showDisclosure: showDisclosure)
        }
        .accessibilityIdentifier("eventRow-\(event.title ?? "Untitled")")
    }
}
