//
//  Constants.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/20/25.
//

import SwiftUI

struct Constants {
    struct AlphabetIndexView {
        static let backgroundOpacity: Double = 0.7
        static let vstackCornerRadius: CGFloat = 8
    }
    
    struct CalendarView {
        static let eventListViewSpacing: CGFloat = 10
        static let headerViewSpacing: CGFloat = 4
        static let zeroSpacing: CGFloat = 0
    }

    struct CategoryListView {
        static let topPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 20
    }
    
    struct EventCategorySection {
        static let verticalPadding: CGFloat = 8
    }
    
    struct EventDetailView {
        static let bodyVStackSpacing: CGFloat = 16
        static let eventMapPreviewFrame: CGFloat = 200
        static let eventMapPreviewVStackSpacing: CGFloat = 2
        static let eventMapPreviewTextPadding: CGFloat = 4
        static let eventMapPreviewCornerRadius: CGFloat = 8
        static let eventMapPreviewShadow: CGFloat = 2
    }
    
    struct EventsGroupedListView {
        static let topFrameHeight: CGFloat = 20
    }
    
    struct EventLocationSection {
        static let frameMaxHeight: CGFloat = 150
    }
    
    struct EventMembersPicker {
        static let topPadding: CGFloat = 20
    }
    
    struct EventRow {
        static let topPadding: CGFloat = 5
    }
    
    struct FriendsListView {
        static let overlayTrailingPadding: CGFloat = 4
    }
    
    struct ProfileRow {
        static let avatarCircleHeight: CGFloat = 40
        static let avatarCircleWidth: CGFloat = 40
        static let hstackPadding: CGFloat = 4
    }
}
