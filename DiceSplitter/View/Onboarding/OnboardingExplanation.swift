//
//  OnboardingExplanation.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct OnboardingExplanation: View {
    let title: String
    let description: String
    let image: String
    let hint: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            Text(hint)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
    }
}

#Preview {
    OnboardingExplanation(title: "Dice", description: "A dice game", image: "die.3", hint: "")
}
