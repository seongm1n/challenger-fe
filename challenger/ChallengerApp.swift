import SwiftUI

@main
struct challengerApp: App {
    @AppStorage("userNickname") private var storedNickname = ""
    
    var body: some Scene {
        WindowGroup {
            if storedNickname.isEmpty {
                LoginView()
            } else {
                ContentView()
            }
        }
    }
}
