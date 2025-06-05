//
//  SwiftUICalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/30/25.
//

import SwiftUI
import UIKit

struct SwiftUICalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    let events: [Event]
    let navigationState: NavigationState
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.current
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.tintColor = Colors.primary
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Redraw event highlights
        uiView.reloadDecorations(forDateComponents: [], animated: true)
        
        if let selectedDate {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            (uiView.selectionBehavior as? UICalendarSelectionSingleDate)?.setSelected(components, animated: true)
        }
    }
    
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
        var parent: SwiftUICalendarView
        
        init(_ parent: SwiftUICalendarView) {
            self.parent = parent
        }
        
        private func hasEvent(on date: Date) -> Bool {
            parent.events.contains {
                guard let eventDate = $0.date else {
                    return false
                }
                
                return Date.isSameDay(date1: eventDate, date2: date)
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let selected = dateComponents?.date else {
                return
            }
            parent.selectedDate = selected
            
            if hasEvent(on: selected) {
                parent.navigationState.navigateToEventsForDate = selected
            }
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = dateComponents.date else {
                return nil
            }
            
            if hasEvent(on: date) {
                return .default(color: Colors.primary)
            }
            
            return nil
        }
    }
}
