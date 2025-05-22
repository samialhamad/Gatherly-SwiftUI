//
//  GetEvents.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

extension GatherlyAPI {
    static func getEvents() -> AnyPublisher<[Event], Never> {
        Just(UserDefaultsManager.loadEvents())
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
