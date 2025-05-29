//
//  EventsViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/26/25.
//

import Combine
import Foundation

final class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false

    private var hasLoaded = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Loaders

    func loadIfNeeded() {
        guard !hasLoaded else {
            return
        }
        fetch()
    }

    func fetch() {
        isLoading = true
        
        GatherlyAPI.getEvents()
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                self?.events = events
                self?.isLoading = false
                self?.hasLoaded = true
            }
            .store(in: &cancellables)
    }

    // MARK: - CRUD

    func create(_ event: Event, completion: @escaping (Event) -> Void = { _ in }) {
        isLoading = true
        
        GatherlyAPI.createEvent(event)
            .receive(on: RunLoop.main)
            .sink { [weak self] createdEvent in
                self?.events.append(createdEvent)
                self?.isLoading = false
                completion(createdEvent)
            }
            .store(in: &cancellables)
    }

    func update(_ updated: Event) {
        isLoading = true
        
        GatherlyAPI.updateEvent(updated)
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedEvent in
                if let index = self?.events.firstIndex(where: { $0.id == updatedEvent.id }) {
                    self?.events[index] = updatedEvent
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    func delete(_ event: Event) {
        isLoading = true
        
        GatherlyAPI.deleteEvent(event)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.events.removeAll { $0.id == event.id }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
