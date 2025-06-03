//
//  DeleteEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteEvent(_ event: Event) -> AnyPublisher<Bool, Never> {
        var events = UserDefaultsManager.loadEvents()
        
        let existed = (event.id != nil && events.keys.contains(event.id!))
        
        if let id = event.id {
            events.removeValue(forKey: id)
            UserDefaultsManager.saveEvents(events)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
