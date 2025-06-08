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
        let dateKeys = groupedEvents.keys.sorted()
        
        ScrollViewReader { proxy in
            groupedEventsList(dateKeys: dateKeys, groupedEvents: groupedEvents, proxy: proxy)
                .toolbar {
                    scrollToTodayToolbarButton(dateKeys: dateKeys, proxy: proxy)
                }
                .onAppear {
                    eventsGroupedListViewModel.scrollToNearestAvailableDay(dateKeys: dateKeys, proxy: proxy)
                }
        }
    }
}

private extension EventsGroupedListView {
    
    // MARK: - Subviews
    
    func groupedEventsList(
        dateKeys: [Date],
        groupedEvents: [Date: [Event]],
        proxy: ScrollViewProxy
    ) -> some View {
        List {
            ForEach(dateKeys, id: \.self) { date in
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
            eventsGroupedListViewModel.scrollToNearestAvailableDay(dateKeys: dateKeys, proxy: proxy)
        }
    }
    
    func scrollToTodayToolbarButton(dateKeys: [Date], proxy: ScrollViewProxy) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if eventsGroupedListViewModel.shouldShowTodayButton(dateKeys: dateKeys) {
                Button {
                    eventsGroupedListViewModel.scrollToNearestAvailableDay(
                        dateKeys: dateKeys,
                        proxy: proxy,
                        initiated: true
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
