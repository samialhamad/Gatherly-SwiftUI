//
//  AlphabetIndexView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct AlphabetIndexView: View {
    let letters: [String]
    var onLetterTap: (String) -> Void

    var body: some View {
        VStack {
            ForEach(letters, id: \.self) { letter in
                Text(letter)
                    .font(.caption)
                    .padding(2)
                    .onTapGesture {
                        onLetterTap(letter)
                    }
            }
        }
        .background(Color(.systemBackground).opacity(Constants.AlphabetIndexView.backgroundOpacity))
        .cornerRadius(Constants.AlphabetIndexView.vstackCornerRadius)
    }
}

#Preview {
    AlphabetIndexView(letters: ["A", "B", "C", "D"]) { letter in
        print("Tapped letter: \(letter)")
    }
}
