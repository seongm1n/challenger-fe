import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var isLoginComplete: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiManager = APIManager.shared
    
    @AppStorage("userNickname") private var storedNickname = ""
    @AppStorage("userID") private var storedUserID = 0
    
    var isButtonEnabled: Bool {
        return !nickname.isEmpty
    }
    
    init() {
    }
    
    func login() {
        guard !nickname.isEmpty else { return }
        
        Task {
            let user = try await apiManager.login(username: nickname)
            
            await MainActor.run {
                storedNickname = user.username
                storedUserID = user.id
                isLoginComplete = true
                print(user)
            }
        }
    }
    
    func logout() {
        storedNickname = ""
        storedUserID = 0
        isLoginComplete = false
        nickname = ""
    }
    
    func getUserId() -> Int {
        return storedUserID
    }
}
