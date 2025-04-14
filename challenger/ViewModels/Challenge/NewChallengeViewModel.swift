import Combine
import Foundation
import SwiftUI

class NewChallengeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var challengeTitle: String = ""
    @Published var challengeDescription: String = ""
    @Published var duration: String = ""
    @Published var targetPeriod: String = ""
    
    @Published var shouldDismiss: Bool = false
        
    private var challengeService: ChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        return !challengeTitle.isEmpty && !challengeDescription.isEmpty && !targetPeriod.isEmpty && (Int(targetPeriod) ?? 0) > 0
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: Date())
    }
    
    // MARK: - Initializer
    init(challengeService: ChallengeService = ChallengeService()) {
        self.challengeService = challengeService
        self.targetPeriod = ""
    }
    
    // MARK: - Methods
    func createChallenge() {
        guard !challengeTitle.isEmpty else { return }
        guard !challengeDescription.isEmpty else { return }
        guard !targetPeriod.isEmpty else { return }
        
        guard let durationValue = Int(targetPeriod) else { return }
        guard durationValue > 0 else { return }
        
        let title = self.challengeTitle
        let description = self.challengeDescription
        
        Task {
            let challenge = Challenge(id: 0, title: title, description: description, duration: durationValue, progress: 0.0)
            try await challengeService.saveChallenge(challenge)
        }
        
        resetForm()
        shouldDismiss = true
    }
    
    func resetForm() {
        challengeTitle = ""
        challengeDescription = ""
        targetPeriod = ""
    }
}
