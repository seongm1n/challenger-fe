import Foundation
import SwiftUI
import Combine

class LastChallengeService {
    private let userDefaults = UserDefaults.standard
    private let lastChallengesKey = "lastChallenges"
    
    private var lastChallengesSubject = CurrentValueSubject<[LastChallenge], Never>([])
    var lastChallengesPublisher: AnyPublisher<[LastChallenge], Never> {
        lastChallengesSubject.eraseToAnyPublisher()
    }
    
    @AppStorage("userID") private var userId = 0
    private let apiManager = APIManager.shared
    
    init() {
        loadLastChallenges()
    }
    
    func saveLastChallenge(_ challenge: Challenge,_ retrospection: String) async throws -> Int {
        let LastChallengeResponse = try await apiManager.saveLastChallenge(
            userId: userId, 
            challengeId: challenge.id, 
            retrospection: retrospection
        )
        return LastChallengeResponse.id
    }
    
    func deleteLastChallenge(id: Int) {
        var lastChallenges = lastChallengesSubject.value
        lastChallenges.removeAll { $0.id == id }
        saveLastChallenges(lastChallenges)
    }
    
    func getLastChallenges() async throws -> [LastChallenge] {
        return try await apiManager.getLastChallenges(userId: userId)
    }
    
    // MARK: - Private Methods
    
    private func loadLastChallenges() {
        guard let data = userDefaults.data(forKey: lastChallengesKey),
              let lastChallenges = try? JSONDecoder().decode([LastChallenge].self, from: data) else {
            lastChallengesSubject.send([])
            return
        }
        
        lastChallengesSubject.send(lastChallenges)
    }
    
    private func saveLastChallenges(_ lastChallenges: [LastChallenge]) {
        guard let data = try? JSONEncoder().encode(lastChallenges) else {
            return
        }
        
        userDefaults.set(data, forKey: lastChallengesKey)
        lastChallengesSubject.send(lastChallenges)
    }
}
