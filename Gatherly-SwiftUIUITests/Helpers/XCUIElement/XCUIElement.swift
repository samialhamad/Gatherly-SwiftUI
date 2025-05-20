//
//  XCUIElement.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

extension XCUIElement {
    func clearAndEnterText(_ newText: String) {
        // Double tap to ensure focus
        tap()
        tap()

        sleep(1)

        if let stringValue = self.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            typeText(deleteString)
        }

        typeText(newText)
    }
}
