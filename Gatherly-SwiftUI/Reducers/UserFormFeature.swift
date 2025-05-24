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
    }
    
    enum Action: Equatable {
        case setFirstName(String)
        case setLastName(String)
        case setAvatarImage(UIImage?)
        case setBannerImage(UIImage?)
        case saveChanges
        case userSaved(User)
        case cancel
        case delegate(DelegateAction)
        
        enum DelegateAction: Equatable {
            case didSave(User)
        }
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
            
            var updatedUser = state.currentUser
            updatedUser.firstName = state.firstName
            updatedUser.lastName = state.lastName
            updatedUser.avatarImageName = avatarImageName
            updatedUser.bannerImageName = bannerImageName
            
            let publisher: AnyPublisher<User, Never>
            if state.isCreatingFriend {
                publisher = GatherlyAPI.createUser(updatedUser)
            } else if updatedUser.id == 1 {
                publisher = GatherlyAPI.updateCurrentUser(updatedUser)
            } else {
                publisher = GatherlyAPI.updateUser(updatedUser)
            }
            
            return .publisher {
                publisher.map(Action.userSaved)
            }
            
        case .userSaved(let updatedUser):
            state.currentUser.firstName = updatedUser.firstName
            state.currentUser.lastName = updatedUser.lastName
            state.currentUser.avatarImageName = updatedUser.avatarImageName
            state.currentUser.bannerImageName = updatedUser.bannerImageName
            
            return .send(.delegate(.didSave(updatedUser)))
            
        case .cancel:
            state.isPresented = false
            return .none
            
        case .delegate:
            return .none
        }
    }
}
