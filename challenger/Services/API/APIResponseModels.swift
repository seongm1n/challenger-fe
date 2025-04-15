import Foundation

// MARK: - API 응답 모델 정의
struct ChallengeResponse: Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let progress: Double?
    let duration: Int
}

struct LastChallengeResponse: Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let startDate: String
    let endDate: String
    let retrospection: String
    let assessment: String
}

struct UserResponse: Codable {
    let id: Int
    let username: String
} 
