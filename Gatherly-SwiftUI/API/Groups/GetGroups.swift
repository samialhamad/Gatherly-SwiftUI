//
//  GetGroups.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

extension GatherlyAPI {
    static func getGroups() -> AnyPublisher<[UserGroup], Never> {
        Just(SampleData.sampleGroups)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
