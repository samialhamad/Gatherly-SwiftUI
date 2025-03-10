//
//  LocationSearchViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/10/25.
//

import Foundation
import MapKit
import Combine

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    private var searchCompleter: MKLocalSearchCompleter
    
    override init() {
        searchCompleter = MKLocalSearchCompleter()
        super.init()
        searchCompleter.delegate = self
        // Optional: customize region or filter types here.
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error updating suggestions: \(error.localizedDescription)")
        suggestions = []
    }
    
    /// Use MKLocalSearch to fetch a Location from a completion.
    func search(for completion: MKLocalSearchCompletion, completionHandler: @escaping (Location?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                completionHandler(nil)
                return
            }
            let coordinate = mapItem.placemark.coordinate
            let location = Location(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude,
                                    name: mapItem.name)
            completionHandler(location)
        }
    }
}
