import SwiftUI

// MARK: - 챌린지 상세 화면
struct ChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ChallengeViewModel
    
    // MARK: - 초기화
    init(challenge: Challenge) {
        _viewModel = StateObject(wrappedValue: ChallengeViewModel(challenge: challenge))
    }
    
    // MARK: - 데이터
    private var certifications: [(day: String, date: String, detail: String)] {
        return []
    }

    // MARK: - 뷰 본문
    var body: some View {
        ZStack {
            StarryBackgroundView()

            VStack(spacing: 0) {
                NavigationBar {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        ChallengeDetailCard(
                            title: viewModel.challenge.title,
                            description: viewModel.challenge.description,
                            duration: "\(viewModel.challenge.duration)일"
                        )

                        ProgressCard(
                            progressValue: viewModel.challenge.progress,
                            progressText: "\(Int(viewModel.challenge.progress * 100))% 완료"
                        )

                        CertificationHistoryCard(certifications: certifications)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                Spacer()

                ActionButtons(
                    onPause: {
                        viewModel.showProgressUpdate()
                    },
                    onReflect: {
                        viewModel.showReflection()
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert("도전 중단", isPresented: $viewModel.showingProgressUpdateView, actions: {
            Button("취소", role: .cancel) {}
            Button("중단하기", role: .destructive) {
                viewModel.completeChallenge()
            }
        }, message: {
            Text("'\(viewModel.challenge.title)' 도전을 중단하시겠습니까?")
        })
        .fullScreenCover(isPresented: $viewModel.showingCompletionView) {
            CompletionView(challenge: viewModel.challenge)
        }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - 네비게이션 바
struct NavigationBar: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
}

// MARK: - 챌린지 상세 카드
struct ChallengeDetailCard: View {
    let title: String
    let description: String
    let duration: String

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.65, blue: 0.95, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 0.5)), radius: 4, x: 0, y: 1)
                
                Text("도전 정보")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.bottom, 5)

            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(description)
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.8))
                .lineSpacing(5)

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.7))
                
                Text("목표 기간: \(duration)")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(type: .details)
    }
}

// MARK: - 진행 상태 카드
struct ProgressCard: View {
    let progressValue: Double
    let progressText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.65, blue: 0.95, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 0.5)), radius: 4, x: 0, y: 1)
                
                Text("진행 상태")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.bottom, 10)

            HStack {
                ProgressBar(value: progressValue)
                    .frame(height: 10)
                
                Text(progressText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(progressTextColor(value: progressValue))
                    .padding(.leading, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(type: .progress)
    }
    
    private func progressTextColor(value: Double) -> Color {
        if value < 0.3 {
            return Color(UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1.0))
        } else if value < 0.7 {
            return Color(UIColor(red: 0.95, green: 0.7, blue: 0.3, alpha: 1.0))
        } else {
            return Color(UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0))
        }
    }
}

// MARK: - 인증 내역 카드
struct CertificationHistoryCard: View {
    let certifications: [(day: String, date: String, detail: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 0.5)), radius: 4, x: 0, y: 1)
                
                Text("인증 내역")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.bottom, 10)

            if certifications.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Text("아직 인증 내역이 없습니다")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                .padding(.vertical, 10)
            } else {
                ForEach(certifications.prefix(3), id: \.day) { cert in
                    CertificationRow(certification: cert)
                }

                if certifications.count > 3 {
                    Button(action: { /* TODO: 전체 인증 내역 보기 액션 */ }) {
                        HStack(spacing: 5) {
                            Text("더 보기")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)))
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 5)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(type: .certification)
    }
}

// MARK: - 인증 내역 행
struct CertificationRow: View {
    let certification: (day: String, date: String, detail: String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Text(certification.day)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(certification.date)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "text.quote")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(.top, 2)
                
                Text(certification.detail)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .cornerRadius(10)
    }
}

// MARK: - 액션 버튼
struct ActionButtons: View {
    var onPause: () -> Void
    var onReflect: () -> Void
    
    var body: some View {
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
                            Color(UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 0.9)),
                            Color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 0.8))
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
            
            Button(action: onReflect) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 16))
                    Text("완료하기")
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
        }
    }
}

// MARK: - 미리보기
struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleChallenge = Challenge(
            id: 1,
            title: "매일 30분 조깅하기",
            description: "매일 아침 30분씩 조깅을 하면서 건강한 하루를 시작하기 위한 도전입니다. 꾸준히 실천하여 건강 습관을 만들어보세요.",
            duration: 30,
            progress: 0.7
        )
        
        ChallengeView(challenge: sampleChallenge)
    }
}
