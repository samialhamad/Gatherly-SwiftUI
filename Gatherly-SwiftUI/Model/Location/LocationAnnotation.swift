//
//  LocationAnnotation.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/11/25.
//

import MapKit

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String?
}
