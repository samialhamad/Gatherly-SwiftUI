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
            DotsLoader()
            
            if let message = message {
                Text(message)
                    .font(.headline)
                    .foregroundColor(Color(Colors.primary))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}
