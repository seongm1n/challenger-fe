import Combine
import Foundation
import SwiftUI

class LastChallengeService {
    @AppStorage("userID") private var userId = 0
    private let apiManager = APIManager.shared
    
    init() {
    }
    
    func saveLastChallenge(_ challenge: Challenge, _ retrospection: String) async throws -> LastChallenge {
        let lastChallengeResponse = try await apiManager.saveLastChallenge(
            userId: userId, 
            challengeId: challenge.id, 
            retrospection: retrospection
        )
        
        // 응답을 LastChallenge 객체로 변환
        return LastChallenge(
            id: lastChallengeResponse.id,
            title: lastChallengeResponse.title,
            description: lastChallengeResponse.description,
            startDate: stringToDate(lastChallengeResponse.startDate),
            endDate: stringToDate(lastChallengeResponse.endDate),
            retrospection: lastChallengeResponse.retrospection,
            assessment: lastChallengeResponse.assessment
        )
    }
    
    func fetchLastChallenges() async throws -> [LastChallenge] {
        return try await apiManager.fetchLastChallenges(userId: userId)
    }
    
    // 날짜 문자열을 Date 객체로 변환
    private func stringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
