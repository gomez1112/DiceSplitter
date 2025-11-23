//
//  OnboardingView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var playerName: String
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    
    @State private var currentPage = 0
    @State private var pageOpacity: Double = 1
    @State private var pageScale: CGFloat = 1
    
    let completion: () -> Void
    
    
    var body: some View {
        ZStack {
            // Enhanced background
            onboardingBackground
            
            VStack(spacing: 30) {
#if os(iOS)
                TabView(selection: $currentPage) {
                    ForEach(0..<6) { index in
                        pageContent(for: index)
                            .tag(index)
                            .scaleEffect(pageScale)
                            .opacity(pageOpacity)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
#else
                // macOS version without page style
                pageContent(for: currentPage)
                    .scaleEffect(pageScale)
                    .opacity(pageOpacity)
#endif
                
                // Custom page indicator
                CustomPageIndicator(currentPage: $currentPage, pageCount: 6)
                    .padding(.vertical)
                
                // Navigation controls
                navigationControls
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .transition(.opacity)
        .onChange(of: currentPage) { oldValue, newValue in
            withAnimation(.easeOut(duration: 0.2)) {
                pageOpacity = 0
                pageScale = 0.95
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    pageOpacity = 1
                    pageScale = 1
                }
            }
        }
#if os(macOS)
        .frame(minWidth: 700, minHeight: 800)
#endif
    }
    
    // MARK: - Background
    var onboardingBackground: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    ColorTheme.background,
                    ColorTheme.secondaryBackground,
                    ColorTheme.primary.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated mesh gradient
            MeshGradientView()
                .opacity(0.2)
            
            // Floating particles
            ParticleView()
                .blendMode(.plusLighter)
                .opacity(0.7)
        }
    }
    
    // MARK: - Page Content
    @ViewBuilder
    func pageContent(for index: Int) -> some View {
        switch index {
            case 0:
                WelcomePage()
            case 1:
                GameplayPage()
            case 2:
                StrategyPage()
            case 3:
                WinningPage()
            case 4:
                PlayerNamePage(playerName: $playerName)
            case 5:
                PersonalizePage(
                    mapSize: $mapSize,
                    playerType: $playerType,
                    numberOfPlayers: $numberOfPlayers,
                    aiDifficulty: $aiDifficulty
                )
            default:
                EmptyView()
        }
    }
    
    // MARK: - Navigation Controls
    var navigationControls: some View {
        HStack {
            if currentPage > 0 {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        currentPage -= 1
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(ColorTheme.primaryText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .glassMorphism(cornerRadius: 25)
                }
                .buttonStyle(ScalingButtonStyle())
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
            
            Spacer()
            
            if currentPage < 5 {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        currentPage += 1
                    }
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: ColorTheme.primary.opacity(0.3), radius: 10, y: 5)
                }
                .buttonStyle(ScalingButtonStyle())
            } else {
                Button {
                    completion()
                } label: {
                    HStack {
                        Text("Get Started")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: ColorTheme.primary.opacity(0.5), radius: 15, y: 5)
                    .shimmer()
                }
                .buttonStyle(ScalingButtonStyle())
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 1.2).combined(with: .opacity)
                ))
            }
        }
    }
}

#Preview {
    OnboardingView(playerName: .constant("Gerard"), mapSize: .constant(CGSize(width: 3, height: 3)), playerType: .constant(.ai), numberOfPlayers: .constant(3), aiDifficulty: .constant(.easy), completion: {})
        .environment(Audio())
}

// MARK: - Player Name Page
struct PlayerNamePage: View {
    @Binding var playerName: String
    @State private var isAnimating = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [ColorTheme.primary.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .blur(radius: 20)
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text("What's Your Name?")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Text("Personalize your gaming experience")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            // Name Input
            VStack(alignment: .leading, spacing: 12) {
                Label("Player Name", systemImage: "person.fill")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.secondaryText)
                
                ZStack(alignment: .trailing) {
                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            isTextFieldFocused = false
                        }
                    
                    // Checkmark overlay
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(ColorTheme.success)
                        .font(.title2)
                        .opacity(playerName.isEmpty ? 0 : 1)
                        .padding(.trailing, 20)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: playerName.isEmpty)
                        .allowsHitTesting(false)
                }
                
                Text("You can change this later in settings")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(ColorTheme.tertiaryText)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
}
struct CustomTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(.title3, design: .rounded, weight: .medium))
            .foregroundStyle(ColorTheme.primaryText)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isFocused ? ColorTheme.primary : ColorTheme.primary.opacity(0.5),
                                lineWidth: 2
                            )
                    )
            )
            .focused($isFocused)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
