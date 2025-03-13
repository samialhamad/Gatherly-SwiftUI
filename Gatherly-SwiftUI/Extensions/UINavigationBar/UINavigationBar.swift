//
//  UINavigationBar.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import UIKit

extension UINavigationBar {
    
    static func applyGatherlyStyle() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = Brand.Colors.primary
        
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: Brand.Colors.secondary
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: Brand.Colors.secondary
        ]
        
        let barButtonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Brand.Colors.secondary
        ]
        
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = barButtonAttributes
        
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = barButtonAttributes
        
        let doneButtonAppearance = UIBarButtonItemAppearance(style: .done)
        doneButtonAppearance.normal.titleTextAttributes = barButtonAttributes
        
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.buttonAppearance = buttonAppearance
        navigationBarAppearance.doneButtonAppearance = doneButtonAppearance
        
        UIBarButtonItem.appearance().tintColor = Brand.Colors.secondary
        UINavigationBar.appearance().tintColor = Brand.Colors.secondary
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
}
