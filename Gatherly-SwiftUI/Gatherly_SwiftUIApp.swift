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
        UINavigationBar.applyGatherlyStyle()
        UITabBar.applyGatherlyStyle()
        UITextField.appearance().tintColor = Brand.Colors.primary
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyGatherlyToolbarStyle()
                .environmentObject(navigationState)
        }
    }
}
