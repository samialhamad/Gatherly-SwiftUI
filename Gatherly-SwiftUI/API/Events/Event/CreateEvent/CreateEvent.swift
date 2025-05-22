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
        var storedEvent = event
        
        if storedEvent.id == nil {
            storedEvent.id = generateID()
        }
        
        var events = UserDefaultsManager.loadEvents()
        events.append(storedEvent)
        UserDefaultsManager.saveEvents(events)
        
        return Just(storedEvent)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
