//
//  Gatherly.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import UIKit

struct Colors {
    static var primary: UIColor {
        return UIColor(red: 121.0 / 255.0, green: 147.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    static var secondary: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 234.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    static var accent: UIColor {
        return UIColor(red: 102.0 / 255.0, green: 110.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    }
    static var tertiary: UIColor {
        return UIColor(red: 41.0 / 255.0, green: 42.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
    }
}

//MARK: - Categories

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
