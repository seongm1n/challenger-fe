import Foundation

// MARK: - Challenge API 관련 기능
extension APIClient {
    func saveChallenge(
        userId: Int,
        title: String,
        description: String,
        duration: Int
    ) async throws -> ChallengeResponse {
        return try await sendRequest(
            endpoint: "challenges",
            method: "POST",
            body: [
                "userId": userId,
                "title": title,
                "description": description,
                "duration": duration
            ]
        )
    }
    
    func getChallenges(userId: Int) async throws -> [Challenge] {
        let responses: [ChallengeResponse] = try await sendRequest(
            endpoint: "challenges/\(userId)",
            method: "GET"
        )
        
        return responses.map { response in
            Challenge(
                id: response.id,
                title: response.title,
                description: response.description,
                duration: response.duration,
                progress: response.progress ?? 0.0
            )
        }
    }
    
    func deleteChallenge(challengeId: Int) async throws {
        try await sendRequestWithoutResponse(
            endpoint: "challenges/\(challengeId)",
            method: "DELETE"
        )
    }
} 
