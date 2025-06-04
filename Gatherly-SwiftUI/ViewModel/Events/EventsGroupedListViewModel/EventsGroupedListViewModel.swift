//
//  EventsGroupedListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import Foundation
import SwiftUI

class EventsGroupedListViewModel: ObservableObject {
    
    func groupEventsByDay(events: [Event]) -> [Date: [Event]] {
        Dictionary(grouping: events, by: { Date.startOfDay($0.date) })
    }
    
    func shouldShowTodayButton(keys: [Date]) -> Bool {
        let today = Date.startOfDay(Date())
        return !keys.contains(today) || keys.first != today
    }
    
    func scrollToNearestAvailableDay(keys: [Date], proxy: ScrollViewProxy) {
        let todayStart = Date.startOfDay(Date())

        if let index = keys.firstIndex(where: { $0 >= todayStart }) {
            let scrollID = "header-\(keys[index])"
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                proxy.scrollTo(scrollID, anchor: .top)
            }
        }
    }
}

