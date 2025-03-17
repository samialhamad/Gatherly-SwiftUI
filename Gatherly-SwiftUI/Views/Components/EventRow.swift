//
//  EventRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack {
            Image(systemName: "calendar.circle")
                .font(.largeTitle)
                .foregroundColor(Color(Brand.Colors.primary))
            
            VStack(alignment: .leading) {
                Text(event.title ?? "Untitled Event")
                    .font(.headline)
                Text(event.description ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(event.startTimestamp != nil ? formattedTime(event.startTimestamp!) : "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
    
    func formattedTime(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EventRow(event: SampleData.sampleEvents.first!)
}
