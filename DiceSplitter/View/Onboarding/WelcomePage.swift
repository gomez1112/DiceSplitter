//
//  WelcomePage.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct WelcomePage: View {
    @State private var titleScale: CGFloat = 0.8
    @State private var titleOpacity: Double = 0
    @State private var iconRotation: Double = -180
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated logo
            ZStack {
                ForEach(1...6, id: \.self) { i in
                    Image(systemName: "die.face.\(i).fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorTheme.primary, ColorTheme.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(Double(i) * 60 + iconRotation))
                        .offset(
                            x: cos(Double(i) * .pi / 3) * 100,
                            y: sin(Double(i) * .pi / 3) * 100
                        )
                        .opacity(titleOpacity)
                }
                
                Image(systemName: "die.face.6.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(iconRotation))
                    .neonGlow(color: ColorTheme.primary, intensity: 8)
            }
            .frame(height: 200)
            
            VStack(spacing: 20) {
                Text("Welcome to")
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
                    .opacity(titleOpacity)
                
                Text("DiceSplitter")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(titleScale)
                    .opacity(titleOpacity)
                
                Text("A strategic game of skill, luck, and territory control")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(titleOpacity)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                titleScale = 1
                titleOpacity = 1
                iconRotation = 0
            }
        }
    }
}

#Preview {
    WelcomePage()
}
