import Combine
import Foundation

class LastChallengesViewModel: ObservableObject {
    // MARK: - Properties
    @Published var lastChallenges: [LastChallenge] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let lastChallengeService: LastChallengeService
    
    // MARK: - Initializer
    init(lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.lastChallengeService = lastChallengeService
    }
    
    // MARK: - Methods
    func loadLastChallenges() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let lastChallenges = try await lastChallengeService.fetchLastChallenges()
            await MainActor.run {
                self.lastChallenges = lastChallenges
                self.isLoading = false
            }
        }
    }
}
