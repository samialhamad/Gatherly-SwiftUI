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
        var currentUser: User
        var firstName: String
        var lastName: String
        var avatarImageName: String?
        var bannerImageName: String?
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

            let updatedUser = UserEditor.saveUser(
                user: state.currentUser,
                firstName: state.firstName,
                lastName: state.lastName,
                avatarImageName: avatarImageName,
                bannerImageName: bannerImageName
            )
            
            state.currentUser = updatedUser
            return .send(.delegate(.didSave(updatedUser)))
            
        case .cancel:
            state.isPresented = false
            return .none
            
        case .delegate:
            return .none
        }
    }
}
