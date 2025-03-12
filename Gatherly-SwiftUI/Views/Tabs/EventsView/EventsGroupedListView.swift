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
    let groupedEvents: [Date: [Event]]
    let onEventSave: (Event) -> Void
    
    var body: some View {
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
            .onAppear {
                scrollToEarliestDay(in: keys, proxy: proxy)
            }
        }
    }
    
    //MARK: - Functions
    
    private func scrollToEarliestDay(in keys: [Date], proxy: ScrollViewProxy) {
        let todayStart = Date.startOfDay(Date())
        if let index = keys.firstIndex(where: { $0 >= todayStart }) {
            let scrollID = "header-\(keys[index])"
            DispatchQueue.main.async {
                proxy.scrollTo(scrollID, anchor: .top)
            }
        }
    }
}
