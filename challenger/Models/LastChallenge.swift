import Foundation

struct LastChallenge: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    var retrospection: String
    var assessment: String
    
    var durationText: String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: startDate, to: endDate)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1년" : "\(years)년"
        } else if let months = components.month, months > 0 {
            return months == 1 ? "1개월" : "\(months)개월"
        } else if let days = components.day, days > 0 {
            return "\(days)일"
        } else {
            return "완료"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LastChallenge, rhs: LastChallenge) -> Bool {
        lhs.id == rhs.id
    }
    
    static func fromChallenge(_ challenge: Challenge, retrospection: String = "", assessment: String = "평가를 기다리는 중입니다") -> LastChallenge {
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -challenge.duration, to: now) ?? now
        
        return LastChallenge(
            id: challenge.id,
            title: challenge.title,
            description: challenge.description,
            startDate: startDate,
            endDate: now,
            retrospection: retrospection,
            assessment: assessment
        )
    }
}
