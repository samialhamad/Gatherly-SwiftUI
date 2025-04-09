//
//  Location.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/10/25.
//

import CoreLocation

struct Location: Codable, Equatable, Hashable {
    var address: String?
    var latitude: Double
    var longitude: Double
    var name: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
