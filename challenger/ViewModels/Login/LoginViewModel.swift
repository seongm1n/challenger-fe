import Combine
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    // MARK: - Properties
    @Published var nickname: String = ""
    @Published var isLoginComplete: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiManager = APIManager.shared
    
    @AppStorage("userNickname") private var storedNickname = ""
    @AppStorage("userID") private var storedUserID = 0
    
    // MARK: - Computed Properties
    var isButtonEnabled: Bool {
        return !nickname.isEmpty
    }
    
    // MARK: - Initializer
    init() {
    }
    
    // MARK: - Methods
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
    
    func fetchUserId() -> Int {
        return storedUserID
    }
}
