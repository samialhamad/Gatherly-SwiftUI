//
//  GetEvents.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

extension GatherlyAPI {
    static func getEvents() -> AnyPublisher<[Event], Never> {
        let events = UserDefaultsManager.loadEvents()
        let eventsArray = Array(events.values)
        
        let sortedEvents = eventsArray.sorted { $0.sortKey < $1.sortKey }
        
        return Just(sortedEvents)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
