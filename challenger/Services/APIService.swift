import Foundation

class APIManager {
    static let shared = APIManager()
    
    private let client = APIClient.shared
    
    private init() {}
    
    // MARK: - User API
    func login(username: String) async throws -> User {
        return try await client.login(username: username)
    }
    
    // MARK: - Challenge API
    func saveChallenge(userId: Int, title: String, description: String, duration: Int) async throws {
        let _ = try await client.saveChallenge(userId: userId, title: title, description: description, duration: duration)
    }
    
    func fetchChallenges(userId: Int) async throws -> [Challenge] {
        return try await client.getChallenges(userId: userId)
    }
    
    func deleteChallenge(challengeId: Int) async throws {
        try await client.deleteChallenge(challengeId: challengeId)
    }
    
    // MARK: - LastChallenge API
    func saveLastChallenge(userId: Int, challengeId: Int, retrospection: String) async throws -> LastChallengeResponse {
        return try await client.saveLastChallenge(userId: userId, challengeId: challengeId, retrospection: retrospection)
    }
    
    func fetchLastChallenges(userId: Int) async throws -> [LastChallenge] {
        return try await client.getLastChallenges(userId: userId)
    }
}
