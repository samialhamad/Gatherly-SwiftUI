//
//  ContentViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var events: [Event] = []
    @Published var groups: [UserGroup] = []
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    private var pendingRequests = 0
    
    func loadAllData() {
        isLoading = true
    }
    
    private func markRequestFinished() {
        pendingRequests -= 1
        if pendingRequests == 0 {
            isLoading = false
        }
    }
}
