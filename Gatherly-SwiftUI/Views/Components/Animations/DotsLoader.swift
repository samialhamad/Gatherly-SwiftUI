//
//  DotsLoader.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import SwiftUI

struct DotsLoader: View {
    @State private var scale: [CGFloat] = [1.0, 1.0, 1.0]
    
    var body: some View {
        HStack(spacing: Constants.DotsLoader
            .hstackSpacing) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color(Colors.primary))
                    .frame(
                        width: Constants.DotsLoader.circleWidth,
                        height: Constants.DotsLoader.circleHeight
                    )
                    .scaleEffect(scale[i])
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: scale[i]
                    )
            }
        }
        .onAppear {
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    withAnimation {
                        scale[i] = 0.5
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scale[i] = 1.0
                        }
                    }
                }
            }
        }
    }
}
