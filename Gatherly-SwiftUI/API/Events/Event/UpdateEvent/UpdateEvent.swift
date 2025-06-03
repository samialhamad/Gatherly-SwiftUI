//
//  UpdateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateEvent(_ updatedEvent: Event) -> AnyPublisher<Event, Never> {
        var events = UserDefaultsManager.loadEvents()
        
        if let id = updatedEvent.id {
            events[id] = updatedEvent
            UserDefaultsManager.saveEvents(events)
        }
        
        return Just(updatedEvent)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
