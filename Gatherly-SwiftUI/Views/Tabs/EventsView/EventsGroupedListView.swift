//
//  EventsGroupedListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import SwiftUI

struct EventsGroupedListView: View {
    @ObservedObject var currentUser: User
    @Binding var events: [Event]
    @StateObject private var viewModel = EventsGroupedListViewModel()
    
    let users: [User]
    let onEventSave: (Event) -> Void
    
    var body: some View {
        let groupedEvents = events.groupEventsByDay
        let keys = groupedEvents.keys.sorted()
        
        ScrollViewReader { proxy in
            groupedEventsList(keys: keys, groupedEvents: groupedEvents, proxy: proxy)
                .toolbar {
                    scrollToTodayToolbarButton(keys: keys, proxy: proxy)
                }
        }
    }
}

private extension EventsGroupedListView {
    
    // MARK: - Subviews

    func groupedEventsList(
        keys: [Date],
        groupedEvents: [Date: [Event]],
        proxy: ScrollViewProxy
    ) -> some View {
        List {
            ForEach(keys, id: \.self) { date in
                let dateLabel = date.formatted(date: .long, time: .omitted)
                let eventsForDate = groupedEvents[date] ?? []

                Section {
                    ForEach(eventsForDate) { event in
                        EventRowLink(
                            currentUser: currentUser,
                            events: $events,
                            event: event,
                            users: users,
                            onSave: onEventSave,
                            showDisclosure: false
                        )
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    Text(dateLabel)
                        .id("header-\(date)")
                }
            }
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: Constants.EventsGroupedListView.topFrameHeight)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                viewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
            }
        }
    }

    func scrollToTodayToolbarButton(keys: [Date], proxy: ScrollViewProxy) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if viewModel.shouldShowTodayButton(keys: keys) {
                Button {
                    viewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
                } label: {
                    Image(systemName: "calendar.badge.clock.rtl")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        EventsGroupedListView(
            currentUser: sampleUser,
            events: .constant(SampleData.sampleEvents),
            users: SampleData.sampleUsers,
            onEventSave: { updatedEvent in
                print("Updated event: \(updatedEvent)")
            }
        )
    }
}
