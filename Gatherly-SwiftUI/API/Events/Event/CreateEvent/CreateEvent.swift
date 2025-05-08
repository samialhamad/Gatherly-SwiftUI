//
//  CreateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func createEvent(_ event: Event) async -> Event {
        var storedEvent = event

        if storedEvent.id == nil {
            storedEvent.id = generateID()
        }

        var events = UserDefaultsManager.loadEvents()
        events.append(storedEvent)
        UserDefaultsManager.saveEvents(events)

        await simulateNetworkDelay()
        return storedEvent
    }
}
