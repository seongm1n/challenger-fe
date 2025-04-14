import SwiftUI

struct LastChallengesView: View {
    @StateObject private var viewModel = LastChallengesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                StarryBackgroundView()
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("완료한 도전 : 총 \(viewModel.lastChallenges.count)개")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.lastChallenges.isEmpty {
                        VStack(spacing: 20) {
                            Text("완료한 도전이 없습니다")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.lastChallenges) { challenge in
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
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadLastChallenges()
            }
        }
    }
}

struct LastChallengeCard: View {
    let challenge: LastChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(challenge.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(challenge.description)
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.7))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(alignment: .center) {
                ProgressBarView(percentage: 1.0)
                    .frame(width: 120, height: 12)
                
                Text("100% 완료!")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)))
                
                Spacer()
                
                Button(action: {
                    let message = "[\(challenge.title)] 도전을 성공적으로 완료했습니다! \(challenge.durationText) 동안 \(challenge.description)"
                    let activityController = UIActivityViewController(
                        activityItems: [message],
                        applicationActivities: nil
                    )
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(activityController, animated: true, completion: nil)
                    }
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
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor(red: 0.35, green: 0.35, blue: 0.5, alpha: 1.0)),
                                Color(UIColor(red: 0.25, green: 0.25, blue: 0.4, alpha: 0.95))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    )
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
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

struct ProgressBarView: View {
    let percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color(UIColor(red: 0.3, green: 0.35, blue: 0.45, alpha: 0.5)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
                
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: min(CGFloat(percentage) * geometry.size.width, geometry.size.width), height: geometry.size.height)
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
                            .frame(width: min(CGFloat(percentage) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    )
                    .shadow(color: Color(UIColor(red: 0.3, green: 0.7, blue: 0.4, alpha: 0.5)), radius: 3, x: 0, y: 0)
            }
        }
    }
}

struct LastChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        LastChallengesView()
    }
}
