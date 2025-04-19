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
        }
        if let months = components.month, months > 0 {
            return months == 1 ? "1개월" : "\(months)개월"
        }
        if let days = components.day, days > 0 {
            return "\(days)일"
        }
        return "완료"
    }
}
