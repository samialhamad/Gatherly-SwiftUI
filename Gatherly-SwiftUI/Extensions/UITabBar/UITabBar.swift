//
//  UITabBar.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import UIKit

extension UITabBar {
    
    static func applyGatherlyStyle() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Colors.primary
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = Colors.secondary
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Colors.secondary
        ]
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = Colors.accent
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Colors.accent
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
