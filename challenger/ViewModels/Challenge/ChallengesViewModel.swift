import Combine
import Foundation

class ChallengesViewModel: ObservableObject {
    // MARK: - Properties
    @Published var challenges: [Challenge] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var showingCompletionView: Bool = false
    @Published var selectedChallengeForReflection: Challenge? = nil
    @Published var selectedChallengeForDetail: Challenge? = nil
    
    @Published var showingPauseConfirmation: Bool = false
    @Published var challengeToConfirm: Challenge? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let challengeService: ChallengeService
    
    static let shared = ChallengesViewModel()
    
    // MARK: - Initializer
    init(challengeService: ChallengeService = ChallengeService()) {
        self.challengeService = challengeService
        loadChallenges()
    }
    
    // MARK: - Methods
    func refreshChallenges() {
        loadChallenges()
    }
    
    func loadChallenges() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let challenges = try await challengeService.fetchChallenges()
            await MainActor.run {
                self.challenges = challenges
                self.isLoading = false
            }
        }
    }
    
    func reflectOnChallenge(id: Int) {
        if let challenge = challenges.first(where: { $0.id == id }) {
            selectedChallengeForReflection = challenge
            showingCompletionView = true
        }
    }
    
    func showPauseConfirmation(for challenge: Challenge) {
        challengeToConfirm = challenge
        showingPauseConfirmation = true
    }
    
    func confirmPauseChallenge() {
        if let challenge = challengeToConfirm {
            challengeService.deleteChallenge(id: challenge.id)
            loadChallenges()
        }
        challengeToConfirm = nil
        showingPauseConfirmation = false
    }
    
    func cancelPauseChallenge() {
        challengeToConfirm = nil
        showingPauseConfirmation = false
    }
}
