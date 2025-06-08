//
//  EventRowLink.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventRowLink: View {
    let event: Event
    var showDisclosure: Bool = true
    
    var body: some View {
        NavigationLink {
            EventDetailView(event: event)
        } label: {
            EventRow(event: event, showDisclosure: showDisclosure)
        }
        .accessibilityIdentifier("eventRow-\(event.title ?? "Untitled")")
    }
}

