import SwiftUI

// MARK: - 카드 스타일 수정자
struct CardModifier: ViewModifier {
    var cardType: CardType = .default
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(backgroundGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderGradient, lineWidth: 1.5)
            )
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private var backgroundGradient: LinearGradient {
        switch cardType {
        case .header, .details:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.18, green: 0.18, blue: 0.28, alpha: 0.9)),
                    Color(UIColor(red: 0.15, green: 0.15, blue: 0.24, alpha: 0.85))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .retrospection, .progress:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.17, green: 0.19, blue: 0.28, alpha: 0.85)),
                    Color(UIColor(red: 0.14, green: 0.16, blue: 0.25, alpha: 0.8))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .evaluation, .certification:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.16, green: 0.18, blue: 0.28, alpha: 0.85)),
                    Color(UIColor(red: 0.13, green: 0.15, blue: 0.24, alpha: 0.8))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 0.8)),
                    Color(UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 0.7))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var borderGradient: LinearGradient {
        switch cardType {
        case .header, .details:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 0.5)),
                    Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.3)),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .retrospection, .certification:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 0.5)),
                    Color(UIColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 0.3)),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .evaluation, .progress:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.5, green: 0.6, blue: 0.9, alpha: 0.5)),
                    Color(UIColor(red: 0.4, green: 0.5, blue: 0.8, alpha: 0.3)),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.3),
                    Color.white.opacity(0.1),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - 카드 타입
enum CardType {
    case `default`, header, details, retrospection, progress, evaluation, certification
}

// MARK: - 카드 스타일 확장
extension View {
    func cardStyle(type: CardType = .default) -> some View {
        modifier(CardModifier(cardType: type))
    }
} 