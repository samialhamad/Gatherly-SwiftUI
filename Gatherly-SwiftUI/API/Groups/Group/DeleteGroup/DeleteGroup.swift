//
//  DeleteGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteGroup(_ group: UserGroup) -> AnyPublisher<Bool, Never> {
        var groups = UserDefaultsManager.loadGroups()
        let originalCount = groups.count
        
        groups.removeAll { $0.id == group.id }
        UserDefaultsManager.saveGroups(groups)
        
        return Just(groups.count < originalCount)
            .eraseToAnyPublisher()
    }
}
