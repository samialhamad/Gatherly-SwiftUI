//
//  EditProfileFeature.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct EditProfileFeature: Reducer {
    struct State: Equatable {
        var firstName: String
        var lastName: String
        var avatarImage: UIImage?
        var bannerImage: UIImage?
        var isPresented: Bool = false
    }

    enum Action: Equatable {
        case setFirstName(String)
        case setLastName(String)
        case setAvatarImage(UIImage?)
        case setBannerImage(UIImage?)
        case saveChanges
        case cancel
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setFirstName(let name):
            state.firstName = name
            return .none

        case .setLastName(let name):
            state.lastName = name
            return .none

        case .setAvatarImage(let image):
            state.avatarImage = image
            return .none

        case .setBannerImage(let image):
            state.bannerImage = image
            return .none

        case .saveChanges:
            // TODO: Save to persistence or emit delegate action
            state.isPresented = false
            return .none

        case .cancel:
            state.isPresented = false
            return .none
        }
    }
}
