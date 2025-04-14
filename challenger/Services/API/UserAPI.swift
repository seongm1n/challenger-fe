import Foundation

// MARK: - User API 확장
extension APIClient {
    func login(username: String) async throws -> User {
        return try await sendRequest(
            endpoint: "users",
            method: "POST",
            body: ["username": username]
        )
    }
} 