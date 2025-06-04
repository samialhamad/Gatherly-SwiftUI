//
//  GroupsViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/26/25.
//

import Combine
import Foundation

final class GroupsViewModel: ObservableObject {
    @Published var groups: [UserGroup] = []
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
        
        GatherlyAPI.getGroups()
            .receive(on: RunLoop.main)
            .sink { [weak self] groups in
                self?.groups = groups
                self?.isLoading = false
                self?.hasLoaded = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CRUD
    
    func create(_ group: UserGroup, completion: @escaping (UserGroup) -> Void = { _ in }) {
        isLoading = true
        
        GatherlyAPI.createGroup(group)
            .receive(on: RunLoop.main)
            .sink { [weak self] createdGroup in
                self?.groups.append(createdGroup)
                self?.isLoading = false
                completion(createdGroup)
            }
            .store(in: &cancellables)
    }
    
    func update(_ group: UserGroup) {
        isLoading = true
        
        GatherlyAPI.updateGroup(group)
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedGroup in
                if let id = updatedGroup.id,
                   let index = self?.groups.firstIndex(where: { $0.id == id }) {
                    self?.groups[index] = updatedGroup
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func delete(_ group: UserGroup) {
        guard let id = group.id,
              let index = groups.firstIndex(where: { $0.id == id })
        else {
            return
        }
        
        let removed = groups.remove(at: index)
        
        GatherlyAPI.deleteGroup(id: id)
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                if !success {
                    self?.groups.insert(removed, at: index)
                }
            }
            .store(in: &cancellables)
    }
}
