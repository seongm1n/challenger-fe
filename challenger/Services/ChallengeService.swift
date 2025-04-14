import Combine
import Foundation
import SwiftUI

class ChallengeService {
    @AppStorage("userID") private var userId = 0
    private let apiManager = APIManager.shared
    
    init() {
    }
    
    func fetchChallenges() async throws -> [Challenge] {
        return try await apiManager.fetchChallenges(userId: userId)
    }
    
    func saveChallenge(_ challenge: Challenge) async throws {
        try await apiManager.saveChallenge(
            userId: userId, 
            title: challenge.title, 
            description: challenge.description, 
            duration: challenge.duration
        )
    }
    
    func deleteChallenge(id: Int) {
        Task {
            try await apiManager.deleteChallenge(challengeId: id)
        }
    }
} 
