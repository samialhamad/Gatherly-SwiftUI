//
//  Brand+EventCategoryIcon.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

extension Brand.EventCategory {
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
    
    var icon: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: Constants.EventCategoryIcon.iconFrameWidth, height: Constants.EventCategoryIcon.iconFrameHeight)
            .padding(Constants.EventCategoryIcon.iconPadding)
            .background(Circle().fill(Color(Brand.Colors.primary)))
            .foregroundColor(.white)
    }
}
