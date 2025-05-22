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
        
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
            UserDefaultsManager.saveEvents(events)
        }
        
        return Just(updatedEvent)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
