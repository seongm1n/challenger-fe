import SwiftUI

struct ChallengesView: View {
    @StateObject private var viewModel = ChallengesViewModel.shared
    
    var body: some View {
        ZStack {
            StarryBackgroundView()
            
            VStack(spacing: 20) {
                Text("도전 목록")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.challenges.isEmpty {
                    VStack(spacing: 20) {
                        Text("현재 진행 중인 도전이 없습니다")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(viewModel.challenges) { challenge in
                                ChallengeCard(
                                    challenge: challenge,
                                    onCardTap: {
                                        viewModel.selectedChallengeForDetail = challenge
                                    },
                                    onPause: {
                                        viewModel.showPauseConfirmation(for: challenge)
                                    },
                                    onReflect: {
                                        viewModel.reflectOnChallenge(id: challenge.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
        }
        .background(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0)))
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
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    let onCardTap: () -> Void
    let onPause: () -> Void
    let onReflect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: onCardTap) {
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
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.vertical, 5)
            
            HStack(spacing: 15) {
                Button(action: onPause) {
                    HStack(spacing: 8) {
                        Image(systemName: "pause.circle")
                            .font(.system(size: 16))
                        Text("중단하기")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color.white.opacity(0.9))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor(red: 0.65, green: 0.35, blue: 0.45, alpha: 0.9)),
                                Color(UIColor(red: 0.55, green: 0.25, blue: 0.35, alpha: 0.85))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onReflect) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil.and.outline")
                            .font(.system(size: 16))
                        Text("회고하기")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)),
                                Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.95))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
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
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 0.8)),
                    Color(UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 0.7))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color(UIColor(red: 0.25, green: 0.3, blue: 0.45, alpha: 0.5)))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.65, blue: 0.95, alpha: 1.0)))
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
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 0.5)), radius: 3, x: 0, y: 0)
            }
        }
    }
}

struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView()
    }
}
