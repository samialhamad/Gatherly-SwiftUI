//
//  EventLocationSection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventLocationSection: View {
    let header: String
    @Binding var locationName: String
    let onSetLocation: (Location?) -> Void
    
    @State private var isSelectingSuggestion = false
    @State private var selectedLocationAddress: String = ""
    @StateObject private var searchViewModel = LocationSearchViewModel()
    
    var body: some View {
        Section(header: Text(header)) {
            HStack {
                TextField("Enter location name", text: $locationName)
                    .accessibilityIdentifier("eventLocationTextField")
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onChange(of: locationName) { _, newValue in
                        guard !isSelectingSuggestion else {
                            isSelectingSuggestion = false
                            return
                        }
                        
                        searchViewModel.queryFragment = newValue
                        
                        if newValue.isEmpty {
                            onSetLocation(nil)
                        }
                    }
            }
            
            if !selectedLocationAddress.isEmpty {
                Text(selectedLocationAddress)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !searchViewModel.suggestions.isEmpty {
                List(searchViewModel.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        isSelectingSuggestion = true
                        searchViewModel.search(for: suggestion) { location in
                            onSetLocation(location)
                            
                            if let name = location?.name {
                                locationName = name
                            }
                            
                            selectedLocationAddress = location?.address ?? ""
                            searchViewModel.suggestions = []
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text(suggestion.subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxHeight: Constants.EventLocationSection.frameMaxHeight)
            }
        }
    }
}
