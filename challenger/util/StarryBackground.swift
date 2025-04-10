import SwiftUI

struct StarryBackgroundView: View {
    let starCount: Int
    let backgroundColor: Color
    
    init(starCount: Int = 100, backgroundColor: Color = Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 1.0))) {
        self.starCount = starCount
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            ForEach(0..<starCount, id: \.self) { i in
                Star(size: CGFloat.random(in: 1...3))
            }
        }
    }
}

struct Star: View {
    let size: CGFloat
    
    @State private var opacity = Double.random(in: 0.1...0.7)
    @State private var position = CGPoint(
        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
    )
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .position(position)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: Double.random(in: 0.5...3.0)).repeatForever().delay(Double.random(in: 0...2))) {
                    opacity = Double.random(in: 0.3...1.0)
                }
            }
    }
}

struct StarryBackground_Previews: PreviewProvider {
    static var previews: some View {
        StarryBackgroundView()
    }
} 
