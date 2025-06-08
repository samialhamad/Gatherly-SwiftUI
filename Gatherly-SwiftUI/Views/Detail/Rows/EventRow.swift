//
//  EventRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    var showDisclosure: Bool = true
    
    var body: some View {
        HStack {
            iconView
            eventInfoView
            Spacer()
            timeAndDisclosureView
        }
        .padding(.vertical, Constants.EventRow.topPadding)
    }
}

private extension EventRow {
    
    // MARK: - Subviews
    
    var iconView: some View {
        Image(systemName: "calendar.circle")
            .font(.largeTitle)
            .foregroundColor(Color(Colors.primary))
    }
    
    var eventInfoView: some View {
        VStack(alignment: .leading) {
            Text(event.title ?? "Untitled Event")
                .font(.headline)
                .foregroundColor(Color(Colors.primary))
            
            Text(event.description ?? "No description")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
    
    var timeAndDisclosureView: some View {
        HStack(spacing: Constants.EventRow.timeAndDisclosureSpacing) {
            if let start = event.startTimestamp {
                Text(Date.formattedTime(start))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if showDisclosure {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(Colors.primary))
            }
        }
    }
}

#Preview {
    EventRow(event: SampleData.sampleEvents.first!)
}
