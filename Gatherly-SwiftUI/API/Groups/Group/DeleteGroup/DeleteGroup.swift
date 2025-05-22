//
//  DeleteGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteGroup(_ groupToDelete: UserGroup) -> AnyPublisher<[UserGroup], Never> {
        var groups = UserDefaultsManager.loadGroups()
        
        groups.removeAll { $0.id == groupToDelete.id }
        UserDefaultsManager.saveGroups(groups)
        
        return Just(groups)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
