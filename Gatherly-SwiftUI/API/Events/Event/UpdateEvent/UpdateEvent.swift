//
//  UpdateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func updateEvent(_ updatedEvent: Event) async -> Event {
        var events = UserDefaultsManager.loadEvents()
        
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
            UserDefaultsManager.saveEvents(events)
        }
        
        await simulateNetworkDelay()
        return updatedEvent
    }
}
