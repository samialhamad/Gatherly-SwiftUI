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
    private var searchCompleter: MKLocalSearchCompleter
    
    @Published var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    override init() {
        searchCompleter = MKLocalSearchCompleter()
        super.init()
        searchCompleter.delegate = self
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    //called whenever autocomplete results are updated
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            self.suggestions = completer.results
        }
    }
    
    //error handling
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error updating suggestions: \(error.localizedDescription)")
        suggestions = []
    }
    
    // Use MKLocalSearch to fetch a precise Location from a completion.
    func search(for completion: MKLocalSearchCompletion, completionHandler: @escaping (Location?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                completionHandler(nil)
                return
            }
            let coordinate = mapItem.placemark.coordinate
            let location = Location(address: mapItem.placemark.title,
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude,
                                    name: mapItem.name)
            
            completionHandler(location)
        }
    }
}
