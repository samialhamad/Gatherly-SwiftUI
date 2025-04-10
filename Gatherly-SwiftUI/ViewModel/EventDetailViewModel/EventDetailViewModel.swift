//
//  EventDetailViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/10/25.
//

import SwiftUI
import MapKit

class EventDetailViewModel: ObservableObject {
    
    func mapOptions(for location: Location) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        if let address = location.address {
            buttons.append(.default(Text("Apple Maps")) {
                self.openInAppleMaps(address: address)
            })
        }
        
        if let googleURL = URL(string: "comgooglemaps://"),
           UIApplication.shared.canOpenURL(googleURL),
           let address = location.address {
            buttons.append(.default(Text("Google Maps")) {
                self.openInGoogleMaps(address: address)
            })
        }
        
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
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?q=\(encodedAddress)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func openInGoogleMaps(address: String) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "comgooglemaps://?q=\(encodedAddress)"
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
}
