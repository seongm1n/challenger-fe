import Combine
import Foundation
import SwiftUI

class LastChallengeService {
    @AppStorage("userID") private var userId = 0
    private let apiManager = APIManager.shared
    
    init() {
    }
    
    func saveLastChallenge(_ challenge: Challenge, _ retrospection: String) async throws -> Int {
        let lastChallengeResponse = try await apiManager.saveLastChallenge(
            userId: userId, 
            challengeId: challenge.id, 
            retrospection: retrospection
        )
        return lastChallengeResponse.id
    }
    
    func fetchLastChallenges() async throws -> [LastChallenge] {
        return try await apiManager.fetchLastChallenges(userId: userId)
    }
}
