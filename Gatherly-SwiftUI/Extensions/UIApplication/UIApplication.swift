//
//  UIApplication.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/2/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
