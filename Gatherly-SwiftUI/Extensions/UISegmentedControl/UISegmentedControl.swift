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

            appearance.backgroundColor = Colors.primary
            appearance.selectedSegmentTintColor = Colors.secondary
            appearance.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            appearance.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        }
    }
