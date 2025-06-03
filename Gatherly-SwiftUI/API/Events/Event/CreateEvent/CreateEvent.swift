//
//  CreateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func createEvent(_ event: Event) -> AnyPublisher<Event, Never> {
        var newEvent = event
        
        if newEvent.id == nil {
            newEvent.id = generateID()
        }
        
        var events = UserDefaultsManager.loadEvents()
        if let id = newEvent.id {
            events[id] = newEvent
        }
        
        UserDefaultsManager.saveEvents(events)
        
        return Just(newEvent)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
