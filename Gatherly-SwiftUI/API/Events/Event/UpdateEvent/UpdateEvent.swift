//
//  UpdateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateEvent(_ event: Event) -> AnyPublisher<Event, Never> {
        var events = UserDefaultsManager.loadEvents()
        
        if let id = event.id {
            events[id] = event
            UserDefaultsManager.saveEvents(events)
        }
        
        return Just(event)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
