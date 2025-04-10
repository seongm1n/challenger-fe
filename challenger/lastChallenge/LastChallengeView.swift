import SwiftUI

struct LastChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let challengeTitle = "매일 명상 10분"
    let challengePeriod = "3개월 도전 | 2023.09.01 - 2023.11.30"
    let reflection = "3개월 동안 매일 10분씩 명상을 하면서 많은 변화를 느꼈습니다. 처음에는 집중하기 어려웠지만, 점점 마음을 비우는 방법을 배웠고 일상 속 스트레스에 대처하는 능력이 향상되었습니다. 특히 아침에 명상을 하면 하루를 더 차분하게 시작할 수 있어서 좋았습니다. 앞으로도 계속 명상을 생활화하고 싶습니다."
    
    let evaluationMarkdown = """
    당신의 회고에서 명상을 통한 긍정적인 변화와 성장이 잘 드러나 있습니다. 특히 다음과 같은 점이 인상적입니다:
    
    ### **꾸준한 실천력**
    3개월 동안 매일 꾸준히 명상을 실천한 의지력이 돋보입니다.
    
    ### **자기 성찰**
    자신의 변화 과정을 잘 인식하고 분석하였습니다.
    
    ### **삶의 변화**
    명상을 통해 실제 일상에서 긍정적인 변화가 있었습니다.
    """
    
    var attributedEvaluation: AttributedString {
        do {
            return try AttributedString(markdown: evaluationMarkdown)
        } catch {
            return AttributedString(evaluationMarkdown)
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            StarryBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
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
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(challengeTitle)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        Text(challengePeriod)
                            .font(.system(size: 18))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("내 회고")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(reflection)
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.8))
                            .lineSpacing(5)
                            .padding(.bottom, 10)
                    }
                    .padding(20)
                    .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("평가")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(attributedEvaluation)
                            .foregroundColor(Color.white.opacity(0.8))
                            .lineSpacing(8)
                            .padding(.bottom, 10)
                    }
                    .padding(20)
                    .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                    .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0)))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct LastChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        LastChallengeView()
    }
}
