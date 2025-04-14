import Combine
import Foundation
import SwiftUI

class CompletionViewModel: ObservableObject {
    // MARK: - Properties
    @Published var retrospectionText: String = ""
    @Published var isCompleted: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    private let challenge: Challenge
    private let challengeService: ChallengeService
    private let lastChallengeService: LastChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(challenge: Challenge, 
         challengeService: ChallengeService = ChallengeService(),
         lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.challenge = challenge
        self.challengeService = challengeService
        self.lastChallengeService = lastChallengeService
    }
    
    // MARK: - Methods
    func saveRetrospection() {
        guard !retrospectionText.isEmpty else {
            errorMessage = "회고 내용을 입력해주세요"
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        Task{
            try await lastChallengeService.saveLastChallenge(challenge, retrospectionText)
        }
        
        isCompleted = true
    }
}
