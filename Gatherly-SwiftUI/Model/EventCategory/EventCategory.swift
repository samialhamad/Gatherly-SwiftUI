//
//  EventCategory.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/4/25.
//

import SwiftUI

enum EventCategory: String, Codable, CaseIterable {
    case food = "Food"
    case entertainment = "Entertainment"
    case travel = "Travel"
    case sports = "Sports"
    case education = "Education"
    case networking = "Networking"
    case other = "Other"
    
    var iconName: String {
        switch self {
        case .food:
            return "fork.knife"
        case .entertainment:
            return "music.note"
        case .travel:
            return "airplane"
        case .sports:
            return "basketball.fill"
        case .education:
            return "book"
        case .networking:
            return "person.2.fill"
        case .other:
            return "questionmark.circle"
        }
    }
    
    @ViewBuilder
    var icon: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(
                width: Constants.EventCategoryIcon.iconFrameWidth,
                height: Constants.EventCategoryIcon.iconFrameHeight
            )
            .padding(Constants.EventCategoryIcon.iconPadding)
            .background(Circle().fill(Color(Colors.primary)))
            .foregroundColor(.white)
    }
}
