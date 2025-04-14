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
    }
    
    func saveLastChallenge(_ challenge: Challenge,_ retrospection: String) async throws -> Int {
        let LastChallengeResponse = try await apiManager.saveLastChallenge(
            userId: userId, 
            challengeId: challenge.id, 
            retrospection: retrospection
        )
        return LastChallengeResponse.id
    }
    
    func getLastChallenges() async throws -> [LastChallenge] {
        return try await apiManager.getLastChallenges(userId: userId)
    }
}
