import Combine
import Foundation
import SwiftUI

class CompletionViewModel: ObservableObject {
    // MARK: - Properties
    @Published var retrospectionText: String = ""
    @Published var isCompleted: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showSuccessView: Bool = false
    @Published var assessment: String? = nil
    
    private let challenge: Challenge
    private let challengeService: ChallengeService
    private let lastChallengeService: LastChallengeService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(challenge: Challenge, 
         challengeService: ChallengeService = ChallengeService(),
         lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.challenge = challenge
        self.challengeService = challengeService
        self.lastChallengeService = lastChallengeService
    }
    
    // MARK: - Methods
    func saveRetrospection() {
        guard !retrospectionText.isEmpty else {
            errorMessage = "회고 내용을 입력해주세요"
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let challenge = self.challenge
                let retrospectionText = self.retrospectionText
                
                let lastChallenge = try await lastChallengeService.saveLastChallenge(challenge, retrospectionText)
                
                let assessment = lastChallenge.assessment
                
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    
                    ChallengesViewModel.shared.refreshChallenges()
            
                    self.assessment = assessment
                    self.isSaving = false
                    self.showSuccessView = true
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    
                    self.isSaving = false
                    self.errorMessage = "저장 중 오류가 발생했습니다"
                }
            }
        }
    }
    
    // 성공 화면에서 확인 버튼 클릭 시 호출되는 함수
    func completeSuccessView() {
        self.isCompleted = true
    }
}
