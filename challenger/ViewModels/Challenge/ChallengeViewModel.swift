import Combine
import Foundation
import SwiftUI

class ChallengeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var challenge: Challenge
    @Published var showingProgressUpdateView: Bool = false
    @Published var showingCompletionView: Bool = false
    @Published var shouldDismiss: Bool = false
    
    private var challengeService: ChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(challenge: Challenge, challengeService: ChallengeService = ChallengeService()) {
        self.challenge = challenge
        self.challengeService = challengeService
    }
    
    // MARK: - Methods
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
