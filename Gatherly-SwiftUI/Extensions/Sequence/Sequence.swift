//
//  Sequence.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/3/25.
//

extension Sequence {
    /// Converts `[Element]` → `[Int: Element]` by using `KeyPath<Element, Int?>`.
    /// Any element whose `id == nil` is omitted.
    func keyedBy(_ id: KeyPath<Element, Int?>) -> [Int: Element] {
        reduce(into: [Int: Element]()) { dict, element in
            if let key = element[keyPath: id] {
                dict[key] = element
            }
        }
    }
}
