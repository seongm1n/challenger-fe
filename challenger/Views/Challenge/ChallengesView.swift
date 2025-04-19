import SwiftUI

struct ChallengesView: View {
    @StateObject private var viewModel = ChallengesViewModel.shared
    @State private var showNewChallenge = false
    
    var body: some View {
        ZStack {
            StarryBackgroundView()
            
            VStack(spacing: 20) {
                HeaderWithAddButton(title: "도전 목록", onAddTap: {
                    showNewChallenge = true
                })
                
                mainContent
                
                Spacer()
            }
        }
        .background(AppColors.background)
        .onAppear {
            viewModel.refreshChallenges()
        }
        .alert("도전 중단", isPresented: $viewModel.showingPauseConfirmation, actions: {
            Button("취소", role: .cancel) {
                viewModel.cancelPauseChallenge()
            }
            Button("중단하기", role: .destructive) {
                viewModel.confirmPauseChallenge()
            }
        }, message: {
            if let challenge = viewModel.challengeToConfirm {
                Text("정말 '\(challenge.title)' 도전을 중단하시겠습니까?")
            } else {
                Text("도전을 중단하시겠습니까?")
            }
        })
        .navigationDestination(item: $viewModel.selectedChallengeForDetail) { challenge in
            ChallengeView(challenge: challenge)
        }
        .fullScreenCover(isPresented: $viewModel.showingCompletionView) { 
            if let challenge = viewModel.selectedChallengeForReflection {
                CompletionView(challenge: challenge)
            }
        }
        .sheet(isPresented: $showNewChallenge) {
            NewChallengeView()
        }
    }
    
    // MARK: - 조건부 메인 콘텐츠
    private var mainContent: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else if viewModel.challenges.isEmpty {
                EmptyStateView()
            } else {
                ChallengeListView(
                    challenges: viewModel.challenges,
                    onCardTap: { challenge in
                        viewModel.selectedChallengeForDetail = challenge
                    },
                    onPause: { challenge in
                        viewModel.showPauseConfirmation(for: challenge)
                    },
                    onReflect: { challenge in
                        viewModel.reflectOnChallenge(id: challenge.id)
                    }
                )
            }
        }
    }
}

// MARK: - 헤더와 추가 버튼
private struct HeaderWithAddButton: View {
    let title: String
    let onAddTap: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onAddTap) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)),
                                    Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.95))
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 42, height: 42)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color(UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 0.5)), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - 로딩 뷰
private struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 에러 뷰
private struct ErrorView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 빈 상태 뷰
private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("현재 진행 중인 도전이 없습니다")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 챌린지 리스트 뷰
private struct ChallengeListView: View {
    let challenges: [Challenge]
    let onCardTap: (Challenge) -> Void
    let onPause: (Challenge) -> Void
    let onReflect: (Challenge) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(challenges) { challenge in
                    ChallengeCard(
                        challenge: challenge,
                        onCardTap: {
                            onCardTap(challenge)
                        },
                        onPause: {
                            onPause(challenge)
                        },
                        onReflect: {
                            onReflect(challenge)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 챌린지 카드
struct ChallengeCard: View {
    let challenge: Challenge
    let onCardTap: () -> Void
    let onPause: () -> Void
    let onReflect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: onCardTap) {
                VStack(alignment: .leading, spacing: 15) {
                    ChallengeInfoContent(challenge: challenge)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.vertical, 5)
            
            HStack(spacing: 15) {
                ActionButton(
                    title: "중단하기",
                    icon: "pause.circle",
                    gradient: AppColors.pauseGradient,
                    action: onPause
                )
                
                ActionButton(
                    title: "완료하기",
                    icon: "pencil.and.outline",
                    gradient: AppColors.reflectGradient,
                    action: onReflect
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - 챌린지 정보 컨텐츠
private struct ChallengeInfoContent: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(challenge.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(challenge.description)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.7))
                .lineSpacing(5)
                .lineLimit(2)
            
            ProgressBar(value: challenge.progress)
                .frame(height: 10)
                .padding(.top, 5)
            
            Text(challenge.progressText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 액션 버튼
private struct ActionButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(gradient)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 프로그레스 바
struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(AppColors.progressBackground)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(AppColors.progressFill)
                    .cornerRadius(5)
                    .overlay(
                        Rectangle()
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
                            .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                            .cornerRadius(5)
                    )
                    .shadow(color: AppColors.progressShadow, radius: 3, x: 0, y: 0)
            }
        }
    }
}

// MARK: - 앱 색상
private enum AppColors {
    static let background = Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0))
    
    static let cardBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 0.8)),
            Color(UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 0.7))
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let pauseGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 0.9)),
            Color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 0.8))
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let reflectGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)),
            Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.95))
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let progressBackground = Color(UIColor(red: 0.25, green: 0.3, blue: 0.45, alpha: 0.5))
    static let progressFill = Color(UIColor(red: 0.4, green: 0.65, blue: 0.95, alpha: 1.0))
    static let progressShadow = Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 0.5))
}

struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView()
    }
}
