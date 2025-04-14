//
//  GetUsers.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

extension GatherlyAPI {
    static func getUsers() -> AnyPublisher<[User], Never> {
        Just(SampleData.sampleUsers)
            .delay(for: .seconds(5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

