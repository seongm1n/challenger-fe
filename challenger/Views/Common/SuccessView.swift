import SwiftUI

struct SuccessView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var rotation: Double = -30
    @State private var showConfetti = false
    @State private var cardOffset: CGFloat = 50
    @State private var showButton: Bool = false
    
    var assessment: String?
    var onComplete: (() -> Void)? = nil
    
    init(assessment: String? = nil, onComplete: (() -> Void)? = nil) {
        self.assessment = assessment
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.07, green: 0.07, blue: 0.15, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(UIColor(red: 0.3, green: 0.35, blue: 0.8, alpha: 0.4)),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 1,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
            
            if showConfetti {
                ConfettiView()
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1.0)),
                                        Color(UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1.0))
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .blur(radius: 4)
                                    .opacity(0.6)
                            )
                            .shadow(color: Color(UIColor(red: 0.95, green: 0.7, blue: 0.2, alpha: 0.6)), radius: 20, x: 0, y: 0)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                    }
                    .offset(y: -60)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    
                    VStack(spacing: 12) {
                        Text("성공!")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 1)
                        
                        Text("도전을 완료했습니다")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.top, -5)
                        
                        // assessment가 있는 경우 표시
                        if let assessment = assessment, !assessment.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("응원 메시지")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                Text(assessment)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(5)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                        }
                        
                        Spacer().frame(height: 15)
                        
                        HStack(spacing: 20) {
                            achievementIcon(
                                icon: "star.fill", 
                                color: Color(UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1.0)),
                                label: "도전"
                            )
                            
                            achievementIcon(
                                icon: "checkmark.circle.fill", 
                                color: Color(UIColor(red: 0.3, green: 0.8, blue: 0.4, alpha: 1.0)),
                                label: "완료"
                            )
                            
                            achievementIcon(
                                icon: "flame.fill", 
                                color: Color(UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)),
                                label: "성취"
                            )
                        }
                        .padding(.top, 10)
                        
                        if showButton {
                            Button(action: {
                                onComplete?()
                            }) {
                                Text("확인")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0)),
                                                Color(UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0))
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .transition(.opacity)
                            .padding(.top, 25)
                        }
                    }
                    .padding(.top, -25)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)),
                                    Color(UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1.0))
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.5),
                                            Color.white.opacity(0.1),
                                            Color.clear,
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 5)
                )
                .offset(y: cardOffset)
                .opacity(opacity)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
                opacity = 1.0
                cardOffset = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showButton = true
                }
            }
        }
    }
    
    private func achievementIcon(icon: String, color: Color, label: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct ConfettiView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    let count = 80
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                ConfettiPiece(
                    color: colors[i % colors.count],
                    position: CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: -50...100)
                    ),
                    size: CGFloat.random(in: 5...12)
                )
            }
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let position: CGPoint
    let size: CGFloat
    
    @State private var animationOffset = CGSize.zero
    @State private var opacity: Double = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
            .offset(animationOffset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                let randomX = CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2)
                let randomY = CGFloat.random(in: UIScreen.main.bounds.height/2...UIScreen.main.bounds.height)
                
                withAnimation(Animation.timingCurve(0.1, 0.8, 0.2, 1, duration: 2.5)) {
                    animationOffset = CGSize(width: randomX, height: randomY)
                    rotation = Double.random(in: 0...360) * 2
                }
                
                withAnimation(Animation.timingCurve(0.1, 0.8, 0.2, 1, duration: 2.0).delay(0.5)) {
                    opacity = 0
                }
            }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
} 
