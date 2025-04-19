import SwiftUI

enum Tab {
    case challenges, history
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.12, green: 0.12, blue: 0.25, alpha: 1.0)),
                    Color(UIColor(red: 0.10, green: 0.10, blue: 0.18, alpha: 1.0))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(UIColor(red: 0.3, green: 0.4, blue: 0.9, alpha: 0.3)),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 90
                    )
                )
                .frame(width: 80, height: 80)
                .offset(x: selectedTab == .challenges ? -80 : 80, y: -15)
                .opacity(0.7)
                .blur(radius: 15)
            
            HStack {
                Spacer()
                
                TabButton(
                    title: "도전",
                    icon: "list.bullet.rectangle",
                    selectedIcon: "list.bullet.rectangle.fill",
                    isSelected: selectedTab == .challenges,
                    animation: animation,
                    action: { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = .challenges
                    }}
                )
                
                Spacer()
                
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 1, height: 30)
                
                Spacer()
                
                TabButton(
                    title: "지난 도전",
                    icon: "clock.arrow.circlepath",
                    selectedIcon: "clock.arrow.circlepath",
                    isSelected: selectedTab == .history,
                    animation: animation,
                    action: { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = .history
                    }}
                )
                
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity)
            .background(
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.07),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 1)
                    Spacer()
                }
            )
            .background(
                Color(UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 0.97))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: -5)
            )
        }
        .frame(height: 83)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let selectedIcon: String
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor(red: 0.3, green: 0.45, blue: 0.9, alpha: 1.0)),
                                        Color(UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 0.8))
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 54, height: 54)
                            .shadow(color: Color(UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 0.5)), radius: 8, x: 0, y: 0)
                            .matchedGeometryEffect(id: "TAB_BACKGROUND", in: animation)
                    }
                    
                    Image(systemName: isSelected ? selectedIcon : icon)
                        .font(.system(size: 22, weight: isSelected ? .bold : .regular))
                        .foregroundColor(isSelected ? .white : .gray)
                        .frame(width: 22, height: 22) // 아이콘 고정 크기
                        .padding(16)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .gray.opacity(0.8))
            }
        }
    }
} 
