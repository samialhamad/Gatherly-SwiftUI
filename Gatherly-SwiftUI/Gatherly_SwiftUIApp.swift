//
//  Gatherly_SwiftUIApp.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

@main
struct Gatherly_SwiftUIApp: App {
    init() {
        GatherlyAppearance.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyGatherlyToolbarStyle()
                .environmentObject(NavigationState())
        }
    }
}
