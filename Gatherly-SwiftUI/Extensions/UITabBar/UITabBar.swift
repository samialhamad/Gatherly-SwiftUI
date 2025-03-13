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
        tabBarAppearance.backgroundColor = Brand.Colors.primary
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = Brand.Colors.secondary
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Brand.Colors.secondary
        ]
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = Brand.Colors.tertiary
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Brand.Colors.tertiary
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
