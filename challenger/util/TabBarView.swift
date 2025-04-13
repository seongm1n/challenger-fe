import SwiftUI

enum Tab {
    case challenges, add, history
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @State private var showNewChallenge = false
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { selectedTab = .challenges }) {
                VStack(spacing: 8) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 24))
                    Text("도전")
                        .font(.system(size: 12))
                }
                .foregroundColor(selectedTab == .challenges ? .white : .gray)
            }
            
            Spacer()
            
            Button(action: {
                showNewChallenge = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 0.25)))
                        .frame(width: 70, height: 70)
                        .blur(radius: 8)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)),
                                    Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.95))
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color(UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 0.5)), radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                        Text("추가")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                }
                .offset(y: -15)
            }
            .sheet(isPresented: $showNewChallenge) {
                NewChallengeView()
            }
            
            Spacer()
            
            Button(action: { selectedTab = .history }) {
                VStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 24))
                    Text("지난 도전")
                        .font(.system(size: 12))
                }
                .foregroundColor(selectedTab == .history ? .white : .gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 15)
        .background(Color(UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)))
    }
} 
