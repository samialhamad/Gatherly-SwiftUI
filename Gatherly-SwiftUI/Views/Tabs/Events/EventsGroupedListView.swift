//
//  EventsGroupedListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import SwiftUI

struct EventsGroupedListView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var viewModel = EventsGroupedListViewModel()
    
    private var currentUser: User? {
        session.currentUser
    }
    
    var body: some View {
        let groupedEvents = session.events.groupEventsByDay
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
                        EventRowLink(event: event, showDisclosure: false)
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
    EventsGroupedListView()
        .environmentObject(AppSession())
}
