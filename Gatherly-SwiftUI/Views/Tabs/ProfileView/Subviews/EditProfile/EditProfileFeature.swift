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
        var allUsers: [User]
        var currentUser: User
        var firstName: String
        var lastName: String
        var avatarImageName: String?
        var bannerImageName: String?
        var isPresented: Bool = false
    }
    
    enum Action: Equatable {
        case setFirstName(String)
        case setLastName(String)
        case setAvatarImageName(String?)
        case setBannerImageName(String?)
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
            
        case .setAvatarImageName(let image):
            state.avatarImageName = image
            return .none
            
        case .setBannerImageName(let image):
            state.bannerImageName = image
            return .none

        case .saveChanges:
            let updatedUsers = UserEditor.saveUser(
                originalUser: state.currentUser,
                firstName: state.firstName,
                lastName: state.lastName,
                avatarImageName: state.avatarImageName,
                bannerImageName: state.bannerImageName,
                existingUsers: state.allUsers
            )
            
            if let updatedUser = updatedUsers.first(where: { $0.id == state.currentUser.id }) {
                state.allUsers = updatedUsers
                state.currentUser = updatedUser
                return .run { send in
                    await send(.delegate(.didSave(updatedUser)))
                }
            }
            state.isPresented = false
            
            return .none

        case .cancel:
            state.isPresented = false
            return .none
        }
    }
}
