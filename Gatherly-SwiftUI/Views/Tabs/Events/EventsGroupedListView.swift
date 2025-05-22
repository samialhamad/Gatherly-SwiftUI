//
//  EventsGroupedListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import Combine
import SwiftUI

struct EventsGroupedListView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var events: [Event] = []
    @StateObject private var viewModel = EventsGroupedListViewModel()

    var body: some View {
        let groupedEvents = events.groupEventsByDay
        let keys = groupedEvents.keys.sorted()
        
        ScrollViewReader { proxy in
            groupedEventsList(keys: keys, groupedEvents: groupedEvents, proxy: proxy)
                .toolbar {
                    scrollToTodayToolbarButton(keys: keys, proxy: proxy)
                }
                .onAppear {
                    GatherlyAPI.getEvents()
                        .receive(on: RunLoop.main)
                        .sink { self.events = $0 }
                        .store(in: &cancellables)
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
    EventsGroupedListView()
}
