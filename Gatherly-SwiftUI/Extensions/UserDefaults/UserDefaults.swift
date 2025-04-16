//
//  UserDefaults.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/15/25.
//

import Foundation

extension UserDefaults {
    
    func setCodable<T: Encodable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: key)
        }
    }

    func getCodable<T: Decodable>(forKey key: String, type: T.Type) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
