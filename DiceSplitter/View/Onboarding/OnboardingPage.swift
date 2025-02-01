struct OnboardingPage: View {
    let title: String
    let description: String
    let image: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)
                .foregroundStyle(.white)
            
            Text(title)
                .font(.title.bold())
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .foregroundColor(.white)
    }
}