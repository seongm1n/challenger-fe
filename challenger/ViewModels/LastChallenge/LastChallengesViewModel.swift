import Foundation
import Combine

class LastChallengesViewModel: ObservableObject {
    @Published var lastChallenges: [LastChallenge] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let lastChallengeService: LastChallengeService
    
    init(lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.lastChallengeService = lastChallengeService
        subscribeToChanges()
    }
    
    func loadLastChallenges() {
        isLoading = true
        errorMessage = nil
        
        Task{
            let lastChallenges = try await lastChallengeService.getLastChallenges()
            await MainActor.run {
                self.lastChallenges = lastChallenges
                self.isLoading = false
            }
        }
    }
    
    private func subscribeToChanges() {
        lastChallengeService.lastChallengesPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lastChallenges in
                self?.lastChallenges = lastChallenges
            }
            .store(in: &cancellables)
    }
}
