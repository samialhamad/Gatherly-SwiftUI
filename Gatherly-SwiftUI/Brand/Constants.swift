//
//  Constants.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/20/25.
//

import SwiftUI

struct Constants {
    struct ActivityIndicator {
        static let scaleEffect: CGFloat = 1.5
        static let vstackSpacing: CGFloat = 16
    }
    
    struct AlphabetIndexView {
        static let backgroundOpacity: Double = 0.7
        static let vstackCornerRadius: CGFloat = 8
        static let textPadding: CGFloat = 2
    }
    
    struct AvatarHeaderView {
        static let avatarBorderWidth: CGFloat = 4
        static let bannerImageTopPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 50
        static let offset: CGFloat = 50
        static let rectangleFrameHeight: CGFloat = 200
        static let size: CGFloat = 100
    }
    
    struct BannerView {
        static let cornerRadius: CGFloat = 12
        static let height: CGFloat = 200
        static let bottomPadding: CGFloat = 8
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
    
    struct ContentView {
        static let calendarViewLoadingString: String = "Getting your events!"
        static let friendsViewLoadingString: String = "Finding your friends!"
    }
    
    struct CreateEventView {
        static let bannerImageHeight: CGFloat = 150
    }
    
    struct CreateGroupView {
        static let groupImageHeight: CGFloat = 100
        static let groupBannerImageHeight: CGFloat = 150
    }
    
    struct EditEventView {
        static let bannerImageHeight: CGFloat = 150
    }
    
    struct EventCategoryIcon {
        static let iconFrameWidth: CGFloat = 20
        static let iconFrameHeight: CGFloat = 20
        static let iconPadding: CGFloat = 6
    }
    
    struct EventCategorySection {
        static let verticalPadding: CGFloat = 8
    }
    
    struct EventDetailView {
        static let bodyVStackSpacing: CGFloat = 16
        static let eventCategoriesViewSpacing: CGFloat = 8
        static let eventMapPreviewButtonPadding: CGFloat = 4
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
        static let timeAndDisclosureSpacing: CGFloat = 8
    }
        
    struct FriendsListView {
        static let overlayTrailingPadding: CGFloat = 4
    }
    
    struct FriendsView {
        static let pickerViewVerticalPadding: CGFloat = 8
    }
    
    struct GroupDetailView {
        static let topPadding: CGFloat = 10
        static let vstackSpacing: CGFloat = 4
    }
    
    struct GroupRow {
        static let avatarCircleSize: CGFloat = 40
        static let hstackPadding: CGFloat = 4
    }
    
    struct ImagePicker {
        static let cornerRadius: CGFloat = 10
        static let imageHight: CGFloat = 150
        static let topPadding: CGFloat = 5
        static let vstackSpacing: CGFloat = 8
        static let vstackVerticalPadding: CGFloat = 4
    }
    
    struct ProfileView {
        static let profileRowIconFrameWidth: CGFloat = 24
        static let profileVStackSpacing: CGFloat = 1
        static let vstackSpacing: CGFloat = 20
    }
    
    struct ProfileDetailView {
        static let friendButtonHorizontalPadding: CGFloat = 32
        static let friendButtonRadius: CGFloat = 12
        static let friendButtonTopPadding: CGFloat = 8
        static let vstackSpacing: CGFloat = 8
    }

    struct ProfileRow {
        static let avatarCircleSize: CGFloat = 40
        static let hstackPadding: CGFloat = 4
    }
}
