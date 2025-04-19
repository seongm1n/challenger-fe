import SwiftUI

// MARK: - 완료된 도전 상세 화면
struct LastChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: LastChallengeViewModel
    
    // MARK: - 초기화
    init(lastChallenge: LastChallenge) {
        _viewModel = StateObject(wrappedValue: LastChallengeViewModel(lastChallenge: lastChallenge))
    }
    
    // MARK: - 뷰 본문
    var body: some View {
        ZStack(alignment: .topLeading) {
            StarryBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    BackNavigationButton(action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                    
                    ChallengeHeaderCard(
                        title: viewModel.lastChallenge.title,
                        dateRange: viewModel.dateRangeText
                    )
                    
                    RetrospectionCard(
                        retrospection: viewModel.lastChallenge.retrospection
                    )
                    
                    EvaluationCard(
                        evaluation: generateAttributedEvaluation()
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0)))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareButton(action: viewModel.shareChallenge)
            }
        }
    }
    
    // MARK: - 마크다운 평가 문자열 변환
    private func generateAttributedEvaluation() -> AttributedString {
        let evaluationMarkdown = viewModel.lastChallenge.assessment
        
        do {
            return try AttributedString(markdown: evaluationMarkdown)
        } catch {
            return AttributedString(evaluationMarkdown)
        }
    }
}

// MARK: - 뒤로가기 버튼
struct BackNavigationButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.leading, 5)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .padding(.top, 60)
        .padding(.bottom, 5)
    }
}

// MARK: - 공유 버튼
struct ShareButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.white)
        }
    }
}

// MARK: - 도전 헤더 카드
struct ChallengeHeaderCard: View {
    let title: String
    let dateRange: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 0.6)), radius: 4, x: 0, y: 1)
                
                Text("완료한 도전")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .padding(.bottom, 5)
            
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text(dateRange)
                .font(.system(size: 18))
                .foregroundColor(Color.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(type: .header)
        .padding(.bottom, 20)
    }
}

// MARK: - 회고 카드
struct RetrospectionCard: View {
    let retrospection: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 0.6)), radius: 4, x: 0, y: 1)
                
                Text("내 회고")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.bottom, 5)
            
            if retrospection.isEmpty {
                EmptyRetrospectionView()
            } else {
                Text(retrospection)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
                    .lineSpacing(5)
                    .padding(.bottom, 10)
            }
        }
        .cardStyle(type: .retrospection)
        .padding(.bottom, 20)
    }
}

// MARK: - 빈 회고 뷰
struct EmptyRetrospectionView: View {
    var body: some View {
        Text("아직 회고가 작성되지 않았습니다. 이 도전을 통해 무엇을 느꼈는지 기록해보세요.")
            .font(.system(size: 16))
            .foregroundColor(.white.opacity(0.6))
            .italic()
    }
}

// MARK: - 평가 카드
struct EvaluationCard: View {
    let evaluation: AttributedString
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor(red: 0.95, green: 0.7, blue: 0.3, alpha: 1.0)))
                    .shadow(color: Color(UIColor(red: 0.85, green: 0.6, blue: 0.2, alpha: 0.6)), radius: 4, x: 0, y: 1)
                
                Text("응원 메시지")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.bottom, 5)
            
            Text(evaluation)
                .foregroundColor(Color.white.opacity(0.8))
                .lineSpacing(8)
                .padding(.bottom, 5)
        }
        .cardStyle(type: .evaluation)
    }
}

// MARK: - 미리보기
struct LastChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        LastChallengeView(lastChallenge: LastChallenge(
            id: 1,
            title: "매일 명상 10분",
            description: "3개월 동안 매일 10분씩 명상하는 도전입니다.",
            startDate: Date().addingTimeInterval(-90 * 24 * 3600),
            endDate: Date(),
            retrospection: "3개월 동안 매일 10분씩 명상을 하면서 많은 변화를 느꼈습니다. 처음에는 집중하기 어려웠지만, 점점 마음을 비우는 방법을 배웠고 일상 속 스트레스에 대처하는 능력이 향상되었습니다.",
            assessment: "3개월 동안 매일 10분씩 명상을 하면서 많은 변화를 느꼈습니다. 처음에는 집중하기 어려웠지만, 점점 마음을 비우는 방법을 배웠고 일상 속 스트레스에 대처하는 능력이 향상되었습니다."
        ))
    }
}
