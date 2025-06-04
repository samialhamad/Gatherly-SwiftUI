//
//  DeleteGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteGroup(id: Int) -> AnyPublisher<Bool, Never> {
        var groups = UserDefaultsManager.loadGroups()
        
        let existed = groups.keys.contains(id)
        if existed {
            groups.removeValue(forKey: id)
            UserDefaultsManager.saveGroups(groups)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
