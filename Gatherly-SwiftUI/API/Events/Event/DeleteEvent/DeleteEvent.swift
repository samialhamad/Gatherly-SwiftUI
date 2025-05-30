//
//  DeleteEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteEvent(_ eventToDelete: Event) -> AnyPublisher<Bool, Never> {
        var events = UserDefaultsManager.loadEvents()
        let originalCount = events.count
        
        events.removeAll { $0.id == eventToDelete.id }
        UserDefaultsManager.saveEvents(events)
        
        return Just(events.count < originalCount)
            .eraseToAnyPublisher()
    }
}
