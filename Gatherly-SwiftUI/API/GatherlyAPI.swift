//
//  GatherlyAPI.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

struct GatherlyAPI {
    static func generateID() -> Int {
        Int(Date().timestamp)
    }
    
    static func simulateNetworkDelay(seconds: Double = 1.0) async {
        let ns = UInt64(seconds * 1_000_000_000) // 1 second
        try? await Task.sleep(nanoseconds: ns)
    }
}
