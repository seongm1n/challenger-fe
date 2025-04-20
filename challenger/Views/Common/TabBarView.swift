import SwiftUI

enum Tab {
    case challenges, history
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 30) {
            TextTab(
                title: "도전",
                isSelected: selectedTab == .challenges,
                animation: animation,
                action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = .challenges
                    }
                }
            )
            
            TextTab(
                title: "지난 도전",
                isSelected: selectedTab == .history,
                animation: animation,
                action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = .history
                    }
                }
            )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 30)
        .background(
            Capsule()
                .fill(Color(UIColor(red: 0.08, green: 0.09, blue: 0.18, alpha: 0.95)))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
        )
    }
}

struct TextTab: View {
    let title: String
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        if isSelected {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(UIColor(red: 0.4, green: 0.56, blue: 1.0, alpha: 1.0)),
                                            Color(UIColor(red: 0.3, green: 0.4, blue: 0.95, alpha: 0.95))
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .matchedGeometryEffect(id: "TAB", in: animation)
                                .shadow(color: Color(UIColor(red: 0.3, green: 0.4, blue: 1.0, alpha: 0.3)), radius: 8, x: 0, y: 4)
                        }
                    }
                )
        }
        .contentShape(Rectangle())
    }
} 
