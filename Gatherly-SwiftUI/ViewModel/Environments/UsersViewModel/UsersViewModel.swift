//
//  UsersViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/26/25.
//

import Combine
import Foundation

final class UsersViewModel: ObservableObject {
    @Published var currentUser: User?
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

        let currentUserPublisher = GatherlyAPI.getUser()
        let usersPublisher = GatherlyAPI.getUsers()

        Publishers.CombineLatest(currentUserPublisher, usersPublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] currentUser, users in
                self?.currentUser = currentUser
                self?.users = users
                self?.isLoading = false
                self?.hasLoaded = true
            }
            .store(in: &cancellables)
    }
    
    func forceReload() {
        hasLoaded = false
        fetch()
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
        let publisher: AnyPublisher<User, Never>

        if updatedUser.id == currentUser?.id {
            publisher = GatherlyAPI.updateCurrentUser(updatedUser)
        } else {
            publisher = GatherlyAPI.updateUser(updatedUser)
        }

        publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                if let index = self?.users.firstIndex(where: { $0.id == user.id }) {
                    self?.users[index] = user
                }
                if user.id == self?.currentUser?.id {
                    self?.currentUser = user
                }
            }
            .store(in: &cancellables)
    }

    func delete(_ user: User) {
        isLoading = true
        
        GatherlyAPI.deleteUser(user)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.users.removeAll { $0.id == user.id }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
