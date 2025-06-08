//
//  EventsGroupedListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import Foundation
import SwiftUI

class EventsGroupedListViewModel: ObservableObject {
    
    private var hasPerformedInitialScroll = false
    
    func groupEventsByDay(events: [Event]) -> [Date: [Event]] {
        Dictionary(grouping: events, by: { Date.startOfDay($0.date) })
    }
    
    func shouldShowTodayButton(dateKeys: [Date]) -> Bool {
        let today = Date.startOfDay(Date())
        return !dateKeys.contains(today) || dateKeys.first != today
    }
    
    func scrollToNearestAvailableDay(
        dateKeys: [Date],
        proxy: ScrollViewProxy,
        initiated: Bool = false
    ) {
        guard initiated || !hasPerformedInitialScroll else {
            return
        }

        let todayStart = Date.startOfDay(Date())
        
        if let index = dateKeys.firstIndex(where: { $0 >= todayStart }) {
            let scrollID = "header-\(dateKeys[index])"
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                proxy.scrollTo(scrollID, anchor: .top)
            }
        }
        
        if !initiated {
            hasPerformedInitialScroll = true
        }
    }
}

