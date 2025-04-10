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
                        .fill(Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    VStack(spacing: 5) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                        Text("추가")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
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