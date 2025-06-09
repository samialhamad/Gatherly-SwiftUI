//
//  EventLocationSection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventLocationSection: View {
    @State private var isSelectingSuggestion = false
    @Binding var locationName: String?
    @State private var selectedLocationAddress: String? = nil
    @StateObject private var searchViewModel = LocationSearchViewModel()
    
    let header: String
    let onSetLocation: (Location?) -> Void
    
    private var locationNameBinding: Binding<String> {
        Binding(
            get: { locationName ?? "" },
            set: { newValue in
                locationName = newValue.isEmpty ? nil : newValue
            }
        )
    }
    
    var body: some View {
        Section(header: Text(header)) {
            HStack {
                TextField("Enter location name", text: locationNameBinding)
                    .accessibilityIdentifier("eventLocationTextField")
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onChange(of: locationNameBinding.wrappedValue) { _, newValue in
                        guard !isSelectingSuggestion else {
                            isSelectingSuggestion = false
                            return
                        }
                        
                        if newValue.isEmpty {
                            selectedLocationAddress = nil
                            locationName = nil
                            onSetLocation(nil)
                            searchViewModel.queryFragment = ""
                        } else {
                            searchViewModel.queryFragment = newValue
                        }
                    }
            }
            
            if let address = selectedLocationAddress {
                Text(address)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !searchViewModel.suggestions.isEmpty {
                List(searchViewModel.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        isSelectingSuggestion = true
                        searchViewModel.search(for: suggestion) { location in
                            onSetLocation(location)
                            locationName = location?.name
                            selectedLocationAddress = location?.address
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
