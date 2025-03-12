//
//  Gatherly_SwiftUIApp.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import SwiftUI

@main
struct Gatherly_SwiftUIApp: App {
    @StateObject var navigationState = NavigationState()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Brand.Colors.primary
        appearance.titleTextAttributes = [.foregroundColor: Brand.Colors.secondary]
        appearance.largeTitleTextAttributes = [.foregroundColor: Brand.Colors.secondary]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationState)
        }
    }
}
