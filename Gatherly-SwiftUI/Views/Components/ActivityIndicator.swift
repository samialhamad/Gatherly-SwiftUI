//
//  ActivityIndicator.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import SwiftUI

struct ActivityIndicator: View {
    var message: String? = nil
    
    var body: some View {
        VStack(spacing: Constants.ActivityIndicator.vstackSpacing) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(Colors.primary)))
                .scaleEffect(Constants.ActivityIndicator.scaleEffect)
            
            if let message = message {
                Text(message)
                    .font(.body)
                    .foregroundColor(Color(Colors.primary))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(Colors.secondary))
        .edgesIgnoringSafeArea(.all)
    }
}
