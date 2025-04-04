//
//  EventsGroupedListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import SwiftUI

struct EventsGroupedListView: View {
    @Binding var events: [Event]
    let users: [User]
    let onEventSave: (Event) -> Void
    @StateObject private var viewModel = EventsGroupedListViewModel()
    
    var body: some View {
        let groupedEvents = events.groupEventsByDay
        let keys = groupedEvents.keys.sorted()
        
        ScrollViewReader { proxy in
            List {
                ForEach(keys, id: \.self) { date in
                    let dateLabel = date.formatted(date: .long, time: .omitted)
                    let eventsForDate = groupedEvents[date] ?? []
                    
                    Section {
                        ForEach(eventsForDate) { event in
                            EventRowLink(
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
            .listStyle(InsetGroupedListStyle())
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: Constants.EventsGroupedListView.topFrameHeight)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    viewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
                }
            }
            .toolbar {
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
    }
}

#Preview {
    EventsGroupedListView(
        events: .constant(SampleData.sampleEvents),
        users: SampleData.sampleUsers,
        onEventSave: { updatedEvent in
            print("Updated event: \(updatedEvent)")
        }
    )
}
