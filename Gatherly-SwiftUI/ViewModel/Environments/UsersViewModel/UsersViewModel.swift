//
//  UsersViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/26/25.
//

import Combine
import Foundation

final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false

    // MARK: - Loaders

    func loadIfNeeded() {
        guard !hasLoaded else {
            return
        }
        
        fetch()
    }

    func fetch() {
        isLoading = true
        
        GatherlyAPI.getUsers()
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                self?.users = users
                self?.isLoading = false
                self?.hasLoaded = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CRUD

    func create(_ user: User, completion: @escaping (User) -> Void = { _ in }) {
        isLoading = true
        
        GatherlyAPI.createUser(user)
            .receive(on: RunLoop.main)
            .sink { [weak self] createdUser in
                self?.users.append(createdUser)
                self?.isLoading = false
                completion(createdUser)
            }
            .store(in: &cancellables)
    }

    func update(_ updatedUser: User) {
        isLoading = true
        
        GatherlyAPI.updateUser(updatedUser)
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                if let index = self?.users.firstIndex(where: { $0.id == user.id }) {
                    self?.users[index] = user
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    func delete(_ user: User) {
        isLoading = true
        
        GatherlyAPI.deleteUser(user)
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                self?.users = users
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
