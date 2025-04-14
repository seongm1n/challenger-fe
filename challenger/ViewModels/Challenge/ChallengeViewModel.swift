import Foundation
import SwiftUI
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var challenge: Challenge
    @Published var showingProgressUpdateView: Bool = false
    @Published var showingCompletionView: Bool = false
    @Published var shouldDismiss: Bool = false
    
    private var challengeService: ChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    init(challenge: Challenge, challengeService: ChallengeService = ChallengeService()) {
        self.challenge = challenge
        self.challengeService = challengeService
    }
    
    func showProgressUpdate() {
        showingProgressUpdateView = true
    }
    
    func completeChallenge() {
        shouldDismiss = true
        challengeService.deleteChallenge(id: challenge.id)
    }
    
    func showReflection() {
        showingCompletionView = true
    }
} 
