//
//  GatherlyAPI.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

struct GatherlyAPI {
    
    static let delayTime: Int = 2
    
    static func generateID() -> Int {
        Int(Date().timestamp)
    }
}
