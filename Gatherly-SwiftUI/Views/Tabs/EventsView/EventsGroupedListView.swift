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
                                onSave: onEventSave
                            )
                        }
                    } header: {
                        Text(dateLabel)
                            .id("header-\(date)")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 14)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    viewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.shouldShowTodayButton(keys: keys) {
                        Button("Today") {
                            viewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
                        }
                        .font(.headline)
                    }
                }
            }
        }
    }
}
