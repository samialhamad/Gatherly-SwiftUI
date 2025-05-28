//
//  Gatherly.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import SwiftUI
import UIKit

struct Colors {
    static var primary: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 151.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    static var secondary: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 234.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    static var accent: UIColor {
        return UIColor(red: 184 / 255.0, green: 177 / 255.0, blue: 211 / 255.0, alpha: 1.0)
    }
    static var tertiary: UIColor {
        return UIColor(red: 41.0 / 255.0, green: 42.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
    }
}

// MARK: - Configure

struct GatherlyAppearance {
    static func configure() {
        UINavigationBar.applyGatherlyStyle()
        UITabBar.applyGatherlyStyle()
        UISegmentedControl.applyGatherlyStyle()
        
        UITextField.appearance().tintColor = Colors.primary
        UITextField.appearance().clearButtonMode = .whileEditing
    }
}

// MARK: - Categories

enum EventCategory: String, Codable, CaseIterable {
    case food = "Food"
    case entertainment = "Entertainment"
    case travel = "Travel"
    case sports = "Sports"
    case education = "Education"
    case networking = "Networking"
    case other = "Other"
    
    static let allCases: [EventCategory] = [.food, .entertainment, .travel, .sports, .education, .networking, .other]
}

// MARK: - SelectionMode

enum SelectionMode {
    case view
    case select(selectedIDs: Binding<Set<Int>>)
}

// MARK: - Tabs

enum Tab: Int {
    case calendar = 0
    case create = 1
    case friends = 2
    case profile = 3
}
