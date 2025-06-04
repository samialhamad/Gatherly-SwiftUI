//
//  UserFormFeature.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct UserFormFeature: Reducer {
    struct State: Equatable {
        var currentUser: User
        var firstName: String
        var lastName: String
        var avatarImageName: String?
        var bannerImageName: String?
        var avatarImage: UIImage?
        var bannerImage: UIImage?
        var isCreatingFriend: Bool = false
        var isPresented: Bool = false
        var isSaving = false
        var didUpdateUser = false
    }
    
    enum Action: Equatable {
        case setFirstName(String)
        case setLastName(String)
        case setAvatarImage(UIImage?)
        case setBannerImage(UIImage?)
        case saveChanges
        case cancel
        case didSave(User)
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
            let avatarImageName = state.avatarImage.flatMap { ImageUtility.saveImageToDocuments(image: $0) }
            let bannerImageName = state.bannerImage.flatMap { ImageUtility.saveImageToDocuments(image: $0) }
            state.isSaving = true
            
            var updatedUser = state.currentUser
            updatedUser.firstName = state.firstName
            updatedUser.lastName = state.lastName
            updatedUser.avatarImageName = avatarImageName
            updatedUser.bannerImageName = bannerImageName
            
            let publisher: AnyPublisher<User, Never>
            if state.isCreatingFriend {
                publisher = GatherlyAPI.createUser(updatedUser)
            } else if updatedUser.id == Constants.currentUserID {
                publisher = GatherlyAPI.updateCurrentUser(updatedUser)
            } else {
                publisher = GatherlyAPI.updateUser(updatedUser)
            }
            
            return .publisher {
                publisher.map(Action.didSave)
            }
            
        case .didSave:
            state.isSaving = false
            state.didUpdateUser = true
            return .none
            
        case .cancel:
            state.isPresented = false
            return .none
        }
    }
}
