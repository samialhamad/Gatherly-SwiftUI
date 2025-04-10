//
//  EventDetailViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/10/25.
//

import SwiftUI
import MapKit

class EventDetailViewModel: ObservableObject {

    func mapOptions(for location: Location, showAppleMaps: @escaping () -> Void, showGoogleMaps: @escaping () -> Void, showWaze: @escaping () -> Void) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []

        buttons.append(.default(Text("Apple Maps"), action: showAppleMaps))

        if let googleURL = URL(string: "comgooglemaps://"),
           UIApplication.shared.canOpenURL(googleURL) {
            buttons.append(.default(Text("Google Maps"), action: showGoogleMaps))
        }

        if let wazeURL = URL(string: "waze://"),
           UIApplication.shared.canOpenURL(wazeURL) {
            buttons.append(.default(Text("Waze"), action: showWaze))
        }

        buttons.append(.cancel())
        return buttons
    }

    func openInAppleMaps(latitude: Double, longitude: Double, name: String?) {
        let encodedName = name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?q=\(encodedName)&ll=\(latitude),\(longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    func openInGoogleMaps(latitude: Double, longitude: Double) {
        let urlString = "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=14"
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
