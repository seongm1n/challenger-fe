import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .challenges
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    tabContent
                        .padding(.bottom, 0)
                    
                    TabBarView(selectedTab: $selectedTab)
                }
            }
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .challenges:
            ChallengesView()
        case .history:
            LastChallengesView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
