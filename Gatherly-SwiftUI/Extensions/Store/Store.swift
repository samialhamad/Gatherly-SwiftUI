//
//  Store.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import Foundation

extension Store: Identifiable where State: Equatable {
    public var id: String { "\(State.self)" }
}
