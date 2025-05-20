//
//  UISegmentedControl.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import SwiftUI

extension UISegmentedControl {
    static func applyGatherlyStyle() {
        let appearance = UISegmentedControl.appearance()
        
        appearance.backgroundColor = Colors.secondary.withAlphaComponent(0.4)
        appearance.selectedSegmentTintColor = Colors.primary
        appearance.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        appearance.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
