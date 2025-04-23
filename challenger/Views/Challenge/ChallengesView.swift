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
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                HStack(spacing: 12) {
                    Image(systemName: "target")
                        .font(.system(size: 22))
                        .foregroundColor(Color(UIColor(red: 0.5, green: 0.85, blue: 1.0, alpha: 1.0)))
                        .shadow(color: Color(UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.7)), radius: 6, x: 0, y: 0)
                    
                    Text(title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                
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
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.1)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color(UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 0.5)), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: true)
                }
            }
            
            Text("목표를 세우고 자신을 발전시켜 보세요")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .padding(.leading, 2)
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }
}

// MARK: - 로딩 뷰
private struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("도전 목록을 불러오는 중...")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 에러 뷰
private struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(Color(UIColor(red: 1.0, green: 0.7, blue: 0.3, alpha: 1.0)))
                .shadow(color: Color(UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.5)), radius: 5, x: 0, y: 2)
            
            Text("오류가 발생했습니다")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.red.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 빈 상태 뷰
private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "list.star")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.5))
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            Text("현재 진행 중인 도전이 없습니다")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Text("오른쪽 상단 + 버튼을 눌러\n새로운 도전을 시작해보세요!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
        }
        .padding(30)
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
                Spacer()
                    .frame(height: 20)
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
