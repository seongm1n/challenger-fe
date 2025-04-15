import Foundation

struct Challenge: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var description: String
    var duration: Int
    var progress: Double = 0.0
    
    init(id: Int, title: String, description: String, duration: Int, progress: Double = 0.0) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.progress = min(1.0, max(0.0, progress))
    }
    
    var progressText: String {
        let percentage = Int(progress * 100)
        return "\(percentage)% 완료"
    }
} 
