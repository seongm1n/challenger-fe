import SwiftUI

struct ChallengesView: View {
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        ChallengeCard(
                            title: "30일 동안 아침 6시 기상하기",
                            description: "아침에 일찍 일어나서 하루를 더 효율적으로 보내고 건강한 수면 습관을 만들기 위한 도전입니다. 30일 동안 매일 아침 6시에 기상하여 인증샷을...",
                            progress: 0.5,
                            progressText: "15일째 진행 중 (50%)",
                            isActive: true
                        )
                        
                        ChallengeCard(
                            title: "매일 1시간 책 읽기",
                            description: "매일 일정 시간을 정해서 책을 읽는 습관을 만들기 위한 도전입니다. 다양한 분야의 책을 읽고 간단한 독후감을 작성하는 챌린지입니다.",
                            progress: 0.75,
                            progressText: "23일째 진행 중 (75%)",
                            isActive: true
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .background(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0)))
    }
}

struct ChallengeCard: View {
    let title: String
    let description: String
    let progress: Double
    let progressText: String
    let isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.7))
                .lineSpacing(5)
            
            ProgressBar(value: progress)
                .frame(height: 10)
                .padding(.top, 5)
            
            Text(progressText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            HStack(spacing: 15) {
                Button(action: {}) {
                    Text("포기하기")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)))
                        .cornerRadius(10)
                }
                
                Button(action: {}) {
                    Text("회고하기")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)))
                        .cornerRadius(10)
                }
            }
        }
        .padding(20)
        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
        .cornerRadius(15)
    }
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)))
                    .cornerRadius(5)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)))
                    .cornerRadius(5)
            }
        }
    }
}

struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView()
    }
}
