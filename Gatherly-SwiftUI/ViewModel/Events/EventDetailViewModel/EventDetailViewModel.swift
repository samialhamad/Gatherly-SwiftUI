//
//  EventDetailViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/10/25.
//

import SwiftUI
import MapKit

class EventDetailViewModel: ObservableObject {
    
    // MARK: - Computed Vars
    
    func planner(for event: Event,
                 currentUser: User?,
                 friendsDict: [Int: User]) -> User? {
        guard let plannerID = event.plannerID else {
            return nil
        }
        
        if let currentUser, plannerID == currentUser.id {
            return currentUser
        } else {
            return friendsDict[plannerID]
        }
    }
    
    func members(for event: Event,
                 currentUser: User?,
                 friendsDict: [Int: User]) -> [User] {
        guard let memberIDs = event.memberIDs else {
            return []
        }
        
        return memberIDs
            .filter { $0 != event.plannerID }
            .compactMap { id in
                if let currentUser, id == currentUser.id {
                    return currentUser
                }
                return friendsDict[id]
            }
    }
    
    // MARK: - Maps
    
    func mapOptions(for location: Location) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        //Apple Maps
        if let address = location.address {
            buttons.append(.default(Text("Apple Maps")) {
                self.openInAppleMaps(address: address)
            })
        }
        
        //Google Maps
        if let googleURL = URL(string: "comgooglemaps://"),
           UIApplication.shared.canOpenURL(googleURL),
           let address = location.address {
            buttons.append(.default(Text("Google Maps")) {
                self.openInGoogleMaps(address: address)
            })
        }
        
        //Waze (no address support, just latitude and longitude)
        if let wazeURL = URL(string: "waze://"),
           UIApplication.shared.canOpenURL(wazeURL) {
            buttons.append(.default(Text("Waze")) {
                self.openInWaze(latitude: location.latitude, longitude: location.longitude)
            })
        }
        
        buttons.append(.cancel())
        return buttons
    }
    
    func openInAppleMaps(address: String) {
        let urlString = "http://maps.apple.com/?q=\(encodedAddress(address))"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func openInGoogleMaps(address: String) {
        let urlString = "comgooglemaps://?q=\(encodedAddress(address))"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func openInWaze(latitude: Double, longitude: Double) {
        let urlString = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Helper Function
    
    private func encodedAddress(_ address: String) -> String {
        address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
