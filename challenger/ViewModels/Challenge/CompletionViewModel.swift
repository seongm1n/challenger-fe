import Foundation
import SwiftUI
import Combine

class CompletionViewModel: ObservableObject {
    @Published var retrospectionText: String = ""
    @Published var isCompleted: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    private let challenge: Challenge
    private let challengeService: ChallengeService
    private let lastChallengeService: LastChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    init(challenge: Challenge, 
         challengeService: ChallengeService = ChallengeService(),
         lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.challenge = challenge
        self.challengeService = challengeService
        self.lastChallengeService = lastChallengeService
    }
    
    func saveRetrospection() {
        guard !retrospectionText.isEmpty else {
            errorMessage = "회고 내용을 입력해주세요"
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        Task{
            let id = try await lastChallengeService.saveLastChallenge(challenge, retrospectionText)
            print("저장 Id\(id) : \(challenge)")
        }
        
        print("회고 내용: \(retrospectionText)")
        print("도전 ID: \(challenge.id)")
        
        isCompleted = true
    }
}
