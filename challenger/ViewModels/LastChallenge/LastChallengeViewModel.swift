import Combine
import Foundation
import SwiftUI
import UIKit

class LastChallengeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var lastChallenge: LastChallenge
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let lastChallengeService: LastChallengeService
    
    // MARK: - Computed Properties
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let startDateString = formatter.string(from: lastChallenge.startDate)
        let endDateString = formatter.string(from: lastChallenge.endDate)
        
        return "\(lastChallenge.durationText) 도전 | \(startDateString) - \(endDateString)"
    }
    
    // MARK: - Initializer
    init(lastChallenge: LastChallenge, lastChallengeService: LastChallengeService = LastChallengeService()) {
        self.lastChallenge = lastChallenge
        self.lastChallengeService = lastChallengeService
    }
    
    // MARK: - Methods
    func shareChallenge() {
        let message = "[\(lastChallenge.title)] 도전을 성공적으로 완료했습니다! \(lastChallenge.durationText) 동안 \(lastChallenge.description)"
        
        let activityController = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

