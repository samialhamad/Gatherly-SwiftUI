//
//  EventsGroupedListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import Combine
import SwiftUI

struct EventsGroupedListView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel
    @StateObject private var eventsGroupedListViewModel = EventsGroupedListViewModel()
    
    var body: some View {
        let groupedEvents = eventsGroupedListViewModel.groupEventsByDay(events: eventsViewModel.events)
        let keys = groupedEvents.keys.sorted()
        
        ScrollViewReader { proxy in
            groupedEventsList(keys: keys, groupedEvents: groupedEvents, proxy: proxy)
                .toolbar {
                    scrollToTodayToolbarButton(keys: keys, proxy: proxy)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        eventsGroupedListViewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
                    }
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
                        EventRowLink(event: event, showDisclosure: false)
                    }
                } header: {
                    Text(dateLabel)
                        .id("header-\(date)")
                        .accessibilityIdentifier("sectionHeader-\(dateLabel)")
                }
            }
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: Constants.EventsGroupedListView.topFrameHeight)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                eventsGroupedListViewModel.scrollToNearestAvailableDay(keys: keys, proxy: proxy)
            }
        }
    }
    
    func scrollToTodayToolbarButton(keys: [Date], proxy: ScrollViewProxy) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if eventsGroupedListViewModel.shouldShowTodayButton(keys: keys) {
                Button {
                    eventsGroupedListViewModel.scrollToNearestAvailableDay(
                        keys: keys,
                        proxy: proxy,
                        iniatied: true
                    )
                } label: {
                    Image(systemName: "calendar.badge.clock.rtl")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    EventsGroupedListView()
}
