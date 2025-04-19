import SwiftUI

struct LoadingOverlay: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            
            BlurView(style: .systemUltraThinMaterialDark)
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .opacity(0.9)
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.5),
                                    Color.purple.opacity(0.3),
                                    Color.blue.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                        }
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.blue,
                                    Color.purple.opacity(0.5)
                                ],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(-rotation * 1.5))
                }
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        scale = 1.1
                    }
                }
                
                Text("저장 중...")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 1)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.4)) {
                    opacity = 1
                }
            }
        }
        .transition(.opacity)
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            LoadingOverlay()
        }
    }
} 
