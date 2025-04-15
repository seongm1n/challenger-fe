import Foundation

// MARK: - LastChallenge API 관련 기능
extension APIClient {
    func saveLastChallenge(
        userId: Int,
        challengeId: Int,
        retrospection: String
    ) async throws -> LastChallengeResponse {
        return try await sendRequest(
            endpoint: "last-challenges",
            method: "POST",
            body: [
                "userId": userId,
                "challengeId": challengeId,
                "retrospection": retrospection
            ]
        )
    }
    
    func getLastChallenges(userId: Int) async throws -> [LastChallenge] {
        let responses: [LastChallengeResponse] = try await sendRequest(
            endpoint: "last-challenges/\(userId)",
            method: "GET"
        )
                
        return responses.map { response in
            LastChallenge(
                id: response.id,
                title: response.title,
                description: response.description,
                startDate: stringToDate(response.startDate),
                endDate: stringToDate(response.endDate),
                retrospection: response.retrospection,
                assessment: response.assessment
            )
        }
    }
    
    // MARK: 유틸리티 메서드
    private func stringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
} 
