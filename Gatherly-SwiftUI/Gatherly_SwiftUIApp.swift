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
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = Brand.Colors.primary
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: Brand.Colors.secondary]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: Brand.Colors.secondary]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Brand.Colors.primary
        
        //selected state
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = Brand.Colors.secondary
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Brand.Colors.secondary
        ]
        
        //unselected state
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = Brand.Colors.tertiary
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Brand.Colors.tertiary
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationState)
        }
    }
}
