//
//  DeleteEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteEvent(id: Int) -> AnyPublisher<Bool, Never> {
        var events = UserDefaultsManager.loadEvents()
        
        let existed = events.keys.contains(id)
        if existed {
            events.removeValue(forKey: id)
            UserDefaultsManager.saveEvents(events)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
