import SwiftUI

enum Tab {
    case challenges, add, history
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    
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
            
            Button(action: { selectedTab = .add }) {
                VStack(spacing: 8) {
                    Image(systemName: "plus.square")
                        .font(.system(size: 24))
                    Text("추가")
                        .font(.system(size: 12))
                }
                .foregroundColor(selectedTab == .add ? .white : .gray)
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