import SwiftUI

// MARK: - 완료된 도전 목록 화면
struct LastChallengesView: View {
    @StateObject private var viewModel = LastChallengesViewModel()
    
    // MARK: - 뷰 본문
    var body: some View {
        NavigationStack {
            ZStack {
                StarryBackgroundView()
                
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(challengeCount: viewModel.lastChallenges.count)
                    
                    if viewModel.isLoading {
                        LoadingIndicator()
                    } else if viewModel.lastChallenges.isEmpty {
                        EmptyStateView()
                    } else {
                        CompletedChallengeList(challenges: viewModel.lastChallenges)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadLastChallenges()
            }
        }
    }
}

// MARK: - 헤더 뷰
private struct HeaderView: View {
    let challengeCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("완료한 도전 : 총 \(challengeCount)개")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 로딩 표시기
private struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 데이터 없음 상태 뷰
private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("완료한 도전이 없습니다")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - 완료된 도전 목록
private struct CompletedChallengeList: View {
    let challenges: [LastChallenge]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(challenges) { challenge in
                    NavigationLink(destination: LastChallengeView(lastChallenge: challenge)) {
                        LastChallengeCard(challenge: challenge)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - 완료된 도전 카드
struct LastChallengeCard: View {
    let challenge: LastChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ChallengeInfo(title: challenge.title, description: challenge.description)
            ChallengeFooter(challenge: challenge)
        }
        .padding(20)
        .background(cardBackground)
        .overlay(cardBorder)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private var cardBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 0.8)),
                Color(UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 0.7))
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
    }
}

// MARK: - 도전 정보
private struct ChallengeInfo: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.7))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - 도전 푸터 영역
private struct ChallengeFooter: View {
    let challenge: LastChallenge
    
    var body: some View {
        HStack(alignment: .center) {
            CompletionProgress()
            
            Spacer()
            
            ShareChallengeButton(challenge: challenge)
        }
    }
}

// MARK: - 완료 진행률 표시
private struct CompletionProgress: View {
    var body: some View {
        HStack(spacing: 10) {
            LastChallengeProgressBar(percentage: 1.0)
                .frame(width: 120, height: 12)
            
            Text("100% 완료!")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)))
        }
    }
}

// MARK: - 도전 공유 버튼
private struct ShareChallengeButton: View {
    let challenge: LastChallenge
    
    var body: some View {
        Button(action: {
            shareChallenge()
        }) {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14))
                Text("공유")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(buttonBackground)
            .overlay(buttonBorder)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    private var buttonBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor(red: 0.35, green: 0.35, blue: 0.5, alpha: 1.0)),
                Color(UIColor(red: 0.25, green: 0.25, blue: 0.4, alpha: 0.95))
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var buttonBorder: some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
    }
    
    private func shareChallenge() {
        let message = "[\(challenge.title)] 도전을 성공적으로 완료했습니다! \(challenge.durationText) 동안 \(challenge.description)"
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

// MARK: - 완료된 도전 진행바
struct LastChallengeProgressBar: View {
    let percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ProgressBarBackground(geometry: geometry)
                ProgressBarForeground(geometry: geometry, percentage: percentage)
            }
        }
    }
}

// MARK: - 진행바 배경
private struct ProgressBarBackground: View {
    let geometry: GeometryProxy
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .foregroundColor(Color(UIColor(red: 0.3, green: 0.35, blue: 0.45, alpha: 0.5)))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
    }
}

// MARK: - 진행바 전경
private struct ProgressBarForeground: View {
    let geometry: GeometryProxy
    let percentage: Double
    
    var body: some View {
        let width = min(CGFloat(percentage) * geometry.size.width, geometry.size.width)
        
        return RoundedRectangle(cornerRadius: 6)
            .frame(width: width, height: geometry.size.height)
            .foregroundColor(Color(UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.0),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: width, height: geometry.size.height)
            )
            .shadow(color: Color(UIColor(red: 0.3, green: 0.7, blue: 0.4, alpha: 0.5)), radius: 3, x: 0, y: 0)
    }
}

// MARK: - 미리보기
struct LastChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        LastChallengesView()
    }
}
