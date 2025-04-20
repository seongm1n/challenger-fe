import SwiftUI

// MARK: - 별이 빛나는 배경 뷰
struct StarryBackgroundView: View {
    let starCount: Int
    let backgroundColor: Color
    let nebulaOpacity: Double 
    let galaxyCount: Int
    
    init(
        starCount: Int = 300, 
        backgroundColor: Color = Color.black,
        nebulaOpacity: Double = 0.7,
        galaxyCount: Int = 5
    ) {
        self.starCount = starCount
        self.backgroundColor = backgroundColor
        self.nebulaOpacity = nebulaOpacity
        self.galaxyCount = galaxyCount
    }
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.02, green: 0.02, blue: 0.1),
                    Color.black
                ]),
                center: .center,
                startRadius: 0,
                endRadius: UIScreen.main.bounds.width
            )
            .ignoresSafeArea()
            
            NebulaEffect()
                .opacity(nebulaOpacity)
            
            ForEach(0..<starCount, id: \.self) { i in
                if i % 30 == 0 {
                    GlowingStar(size: CGFloat.random(in: 2...4))
                } else {
                    CosmicStar(size: CGFloat.random(in: 0.8...2.5))
                }
            }
            
            ForEach(0..<galaxyCount, id: \.self) { _ in
                DistantGalaxy()
            }
        }
    }
}

// MARK: - 일반 별 컴포넌트
struct CosmicStar: View {
    let size: CGFloat
    let color: Color
    
    @State private var opacity = Double.random(in: 0.3...0.8)
    @State private var position = CGPoint(
        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
    )
    
    init(size: CGFloat) {
        self.size = size
        
        let colorChoice = Int.random(in: 0...10)
        if colorChoice < 2 {
            self.color = Color(red: 0.8, green: 0.9, blue: 1.0)
        } else if colorChoice < 4 {
            self.color = Color(red: 1.0, green: 0.9, blue: 0.8)
        } else {
            self.color = Color.white
        }
    }
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: Double.random(in: 2.0...6.0)).repeatForever().delay(Double.random(in: 0...2))) {
                    opacity = Double.random(in: 0.4...1.0)
                }
            }
    }
}

// MARK: - 발광 별 컴포넌트
struct GlowingStar: View {
    let size: CGFloat
    
    @State private var glowOpacity = Double.random(in: 0.3...0.7)
    @State private var position = CGPoint(
        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
    )
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: size * 3, height: size * 3)
                .blur(radius: size * 1.5)
                .opacity(glowOpacity * 0.4)
            
            Circle()
                .fill(Color.white)
                .frame(width: size * 1.5, height: size * 1.5)
                .blur(radius: size * 0.5)
                .opacity(glowOpacity * 0.6)
            
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
        }
        .position(position)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: Double.random(in: 1.5...4.0)).repeatForever()) {
                glowOpacity = Double.random(in: 0.5...0.9)
            }
        }
    }
}

// MARK: - 성운 효과 컴포넌트
struct NebulaEffect: View {
    @State private var phase = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let colors = [
                    Color(red: 0.1, green: 0, blue: 0.3, opacity: 0.1),
                    Color(red: 0, green: 0.1, blue: 0.2, opacity: 0.1),
                    Color(red: 0.05, green: 0, blue: 0.15, opacity: 0.15)
                ]
                
                for i in 0..<3 {
                    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    let path = createNebulousPath(in: rect, seed: CGFloat(i) + CGFloat(phase))
                    
                    context.fill(
                        path,
                        with: .color(colors[i % colors.count])
                    )
                }
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                    phase = 10.0
                }
            }
        }
        .opacity(0.7)
    }
    
    func createNebulousPath(in rect: CGRect, seed: CGFloat) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        let controlPoints = 8
        for i in 0...controlPoints {
            let x = width * CGFloat(i) / CGFloat(controlPoints)
            let y = height * (0.3 + 0.4 * sin(CGFloat(i) + seed * 0.2) * cos(CGFloat(i) * 2 + seed * 0.3))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let prevX = width * CGFloat(i-1) / CGFloat(controlPoints)
                let prevY = height * (0.3 + 0.4 * sin(CGFloat(i-1) + seed * 0.2) * cos(CGFloat(i-1) * 2 + seed * 0.3))
                
                let ctrl1X = prevX + (x - prevX) * 0.5
                let ctrl1Y = prevY + CGFloat.random(in: -50...50)
                
                let ctrl2X = prevX + (x - prevX) * 0.5
                let ctrl2Y = y + CGFloat.random(in: -50...50)
                
                path.addCurve(
                    to: CGPoint(x: x, y: y),
                    control1: CGPoint(x: ctrl1X, y: ctrl1Y),
                    control2: CGPoint(x: ctrl2X, y: ctrl2Y)
                )
            }
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - 원거리 은하 컴포넌트
struct DistantGalaxy: View {
    @State private var rotation = Double.random(in: 0...360)
    @State private var position = CGPoint(
        x: CGFloat.random(in: 50...UIScreen.main.bounds.width-50),
        y: CGFloat.random(in: 50...UIScreen.main.bounds.height-50)
    )
    let size = CGFloat.random(in: 5...15)
    let opacity = Double.random(in: 0.1...0.3)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: size/2, height: size/2)
                .blur(radius: 1)
            
            Ellipse()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size
                    )
                )
                .frame(width: size*2, height: size)
                .rotationEffect(Angle(degrees: rotation))
        }
        .position(position)
        .opacity(opacity)
        .blur(radius: 1)
    }
}

// MARK: - 프리뷰
struct StarryBackground_Previews: PreviewProvider {
    static var previews: some View {
        StarryBackgroundView()
    }
} 
