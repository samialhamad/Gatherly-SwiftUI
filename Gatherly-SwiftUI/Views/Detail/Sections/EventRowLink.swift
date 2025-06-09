//
//  EventRowLink.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventRowLink: View {
    let event: Event
    
    var body: some View {
        NavigationLink {
            EventDetailView(event: event)
        } label: {
            EventRow(event: event)
        }
        .accessibilityIdentifier("eventRow-\(event.title ?? "Untitled")")
    }
}

