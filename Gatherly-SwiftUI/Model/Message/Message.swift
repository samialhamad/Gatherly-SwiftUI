//
//  Message.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct Message: Equatable, Hashable {
    var id: Int?
    var eventID: Int?
    var timestamp: Int?
    var userID: Int
    var message: String
    var read: Bool?
}
