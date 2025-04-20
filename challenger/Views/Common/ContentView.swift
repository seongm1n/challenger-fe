import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .challenges
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                VStack(spacing: 0) {
                    tabContent
                        .padding(.bottom, 0)
                }
                
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 1)
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - 배경 뷰
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.06, green: 0.07, blue: 0.16, alpha: 1.0)),
                    Color(UIColor(red: 0.1, green: 0.11, blue: 0.22, alpha: 1.0))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Color(UIColor(red: 0.07, green: 0.08, blue: 0.18, alpha: 0.85))
                .ignoresSafeArea()
            
            glowEffects
        }
        .ignoresSafeArea()
    }
    
    // MARK: - 발광 효과
    private var glowEffects: some View {
        ZStack {
            createGlowCircle(
                colors: [Color(UIColor(red: 0.3, green: 0.4, blue: 0.95, alpha: 0.2)), Color.clear],
                radius: 250,
                size: 400,
                offset: CGPoint(x: -120, y: -280),
                blur: 35
            )
            
            createGlowCircle(
                colors: [Color(UIColor(red: 0.35, green: 0.35, blue: 0.85, alpha: 0.15)), Color.clear],
                radius: 180,
                size: 300,
                offset: CGPoint(x: 170, y: -200),
                blur: 30
            )
            
            createGlowCircle(
                colors: [Color(UIColor(red: 0.4, green: 0.3, blue: 0.9, alpha: 0.15)), Color.clear],
                radius: 180,
                size: 350,
                offset: CGPoint(x: -150, y: 300),
                blur: 40
            )
            
            createGlowCircle(
                colors: [Color(UIColor(red: 0.4, green: 0.3, blue: 0.9, alpha: 0.15)), Color.clear],
                radius: 160,
                size: 300,
                offset: CGPoint(x: 160, y: 320),
                blur: 28
            )
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color(UIColor(red: 0.4, green: 0.5, blue: 1.0, alpha: 0.2)),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: -100)
                .blur(radius: 2)
        }
    }
    
    // MARK: - 발광 원 생성 함수
    private func createGlowCircle(colors: [Color], radius: CGFloat, size: CGFloat, offset: CGPoint, blur: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: colors),
                    center: .center,
                    startRadius: 1,
                    endRadius: radius
                )
            )
            .frame(width: size, height: size)
            .offset(x: offset.x, y: offset.y)
            .blur(radius: blur)
    }
    
    // MARK: - 탭 콘텐츠
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .challenges:
            ChallengesView()
        case .history:
            LastChallengesView()
        }
    }
}

#Preview {
    ContentView()
}
