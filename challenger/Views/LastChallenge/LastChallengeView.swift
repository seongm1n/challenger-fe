import SwiftUI

struct LastChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: LastChallengeViewModel
    
    init(lastChallenge: LastChallenge) {
        _viewModel = StateObject(wrappedValue: LastChallengeViewModel(lastChallenge: lastChallenge))
    }
    
    var attributedEvaluation: AttributedString {
        let evaluationMarkdown = """
        \(viewModel.lastChallenge.assessment)
        """
        
        do {
            return try AttributedString(markdown: evaluationMarkdown)
        } catch {
            return AttributedString(evaluationMarkdown)
        }
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 0.8)),
                Color(UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 0.7))
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    func cardStyle<T: View>(_ content: T) -> some View {
        content
            .padding(20)
            .background(backgroundGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
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
    
    var headerSection: some View {
        cardStyle(
            VStack(alignment: .leading, spacing: 15) {
                Text(viewModel.lastChallenge.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text(viewModel.dateRangeText)
                    .font(.system(size: 18))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.bottom, 20)
    }
    
    var retrospectionSection: some View {
        cardStyle(
            VStack(alignment: .leading, spacing: 15) {
                Text("내 회고")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                if viewModel.lastChallenge.retrospection.isEmpty {
                    Text("아직 회고가 작성되지 않았습니다. 이 도전을 통해 무엇을 느꼈는지 기록해보세요.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.6))
                        .italic()
                } else {
                    Text(viewModel.lastChallenge.retrospection)
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.8))
                        .lineSpacing(5)
                        .padding(.bottom, 10)
                }
            }
        )
        .padding(.bottom, 20)
    }
    
    var evaluationSection: some View {
        cardStyle(
            VStack(alignment: .leading, spacing: 15) {
                Text("평가")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text(attributedEvaluation)
                    .foregroundColor(Color.white.opacity(0.8))
                    .lineSpacing(8)
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            StarryBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    backButton
                    headerSection
                    retrospectionSection
                    evaluationSection
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
                Button(action: {
                    viewModel.shareChallenge()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

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
