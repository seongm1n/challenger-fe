import SwiftUI

struct ChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let challengeTitle = "매일 30분 조깅하기"
    let description = "매일 아침 30분씩 조깅을 하면서 건강한 하루를 시작하기 위한 도전입니다. 꾸준히 실천하여 건강 습관을 만들어보세요."
    let startDate = "2023년 12월 1일"
    let targetPeriod = "30일"
    let progressValue: Double = 0.7
    let progressText = "21일째 (70%)"
    let certifications: [(day: String, date: String, detail: String)] = [
        ("21일차 인증", "2023.12.21", "오늘도 30분 조깅 완료!..."),
        ("20일차 인증", "2023.12.20", "비가 와서 실내에서..."),
        ("19일차 인증", "2023.12.19", "아침 공기가 상쾌해서...")
    ]

    var body: some View {
        ZStack {
            StarryBackgroundView()

            VStack(spacing: 0) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 10)

                ScrollView {
                    VStack(spacing: 20) {
                        ChallengeDetailCard(
                            title: challengeTitle,
                            description: description,
                            startDate: startDate,
                            targetPeriod: targetPeriod
                        )

                        ProgressCard(
                            progressValue: progressValue,
                            progressText: progressText
                        )

                        CertificationHistoryCard(certifications: certifications)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                Spacer()

                ActionButtons()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

struct ChallengeDetailCard: View {
    let title: String
    let description: String
    let startDate: String
    let targetPeriod: String

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(description)
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.8))
                .lineSpacing(5)

            VStack(alignment: .leading, spacing: 5) {
                Text("시작일: \(startDate)")
                Text("목표 기간: \(targetPeriod)")
            }
            .font(.system(size: 14))
            .foregroundColor(Color.white.opacity(0.6))
            .padding(.top, 10)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
        .cornerRadius(15)
    }
}

struct ProgressCard: View {
    let progressValue: Double
    let progressText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("진행 상태")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                ProgressBar(value: progressValue)
                    .frame(height: 10)
                
                Text(progressText)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.8))
                    .padding(.leading, 10)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
        .cornerRadius(15)
    }
}

struct CertificationHistoryCard: View {
    let certifications: [(day: String, date: String, detail: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("인증 내역")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 5)

            ForEach(certifications.prefix(3), id: \.day) { cert in // 상위 3개만 표시
                CertificationRow(certification: cert)
            }

            // 더 보기 버튼
            if certifications.count > 3 {
                Button(action: { /* TODO: 전체 인증 내역 보기 액션 */ }) {
                    Text("더 보기")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 5)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
        .cornerRadius(15)
    }
}

struct CertificationRow: View {
    let certification: (day: String, date: String, detail: String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(certification.day)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text(certification.date)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            Text(certification.detail)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.7))
                .lineLimit(1)
        }
        .padding(15)
        .background(Color(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)))
        .cornerRadius(10)
    }
}

struct ActionButtons: View {
    var body: some View {
        HStack(spacing: 15) {
            Button(action: { /* TODO: 포기하기 액션 */ }) {
                Text("포기하기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color(UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)))
                    .cornerRadius(10)
            }
            
            Button(action: { /* TODO: 회고하기 액션 */ }) {
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
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
    }
}
