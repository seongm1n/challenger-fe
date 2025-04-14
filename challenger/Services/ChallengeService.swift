import Foundation
import SwiftUI
import Combine

class ChallengeService {
    private let userDefaults = UserDefaults.standard
    private let challengesKey = "challenges"
    
    private var challengesSubject = CurrentValueSubject<[Challenge], Never>([])
    var challengesPublisher: AnyPublisher<[Challenge], Never> {
        challengesSubject.eraseToAnyPublisher()
    }
    
    @AppStorage("userID") private var userId = 0
    private let apiManager = APIManager.shared
    
    init() {
        loadChallenges()
    }
    
    func getChallenges() async throws -> [Challenge] {
        return try await apiManager.getChallenges(userId: userId)
    }
    
    func saveChallenge(_ challenge: Challenge) async throws -> Int {
        let ChallengeResponse = try await apiManager.saveChallenge(
            userId: userId, 
            title: challenge.title, 
            description: challenge.description, 
            duration: challenge.duration
        )
        return ChallengeResponse.id
    }
    
    func deleteChallenge(id: Int) {
        Task {
            do {
                try await apiManager.deleteChallenge(challengeId: id)
                print("Server : 챌린지 삭제 성공!")
            } catch {
                print("챌린지 삭제 실패: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
        
    private func loadChallenges() {
        guard let data = userDefaults.data(forKey: challengesKey),
              let challenges = try? JSONDecoder().decode([Challenge].self, from: data) else {
            challengesSubject.send([])
            return
        }
        
        challengesSubject.send(challenges)
    }
    
    private func saveChallenges(_ challenges: [Challenge]) {
        guard let data = try? JSONEncoder().encode(challenges) else {
            return
        }
        
        userDefaults.set(data, forKey: challengesKey)
        challengesSubject.send(challenges)
    }
} 
