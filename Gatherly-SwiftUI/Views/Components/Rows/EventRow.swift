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
            Image(systemName: "calendar.circle")
                .font(.largeTitle)
                .foregroundColor(Color(Colors.primary))
            
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
            
            Spacer()
            
            Text(event.startTimestamp != nil ? formattedTime(event.startTimestamp!) : "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if showDisclosure {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(Colors.primary))
            }
        }
        .padding(.vertical, Constants.EventRow.topPadding)
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
