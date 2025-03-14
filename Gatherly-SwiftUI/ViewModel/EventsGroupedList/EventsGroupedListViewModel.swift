//
//  EventsGroupedListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import Foundation
import SwiftUI

class EventsGroupedListViewModel: ObservableObject {
    
    func shouldShowTodayButton(keys: [Date]) -> Bool {
        let today = Date.startOfDay(Date())
        return !keys.contains(today) || keys.first != today
    }
    
    func scrollToNearestAvailableDay(keys: [Date], proxy: ScrollViewProxy) {
        let todayStart = Date.startOfDay(Date())

        if let index = keys.firstIndex(where: { $0 >= todayStart }) {
            let scrollID = "header-\(keys[index])"
            DispatchQueue.main.async {
                proxy.scrollTo(scrollID, anchor: .top)
            }
        }
    }
}

