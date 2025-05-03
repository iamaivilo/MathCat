import Foundation

struct QuizResult: Codable, Identifiable {
    let id = UUID()
    let grade: Grade
    let bestScore: Int
    let totalQuestions: Int
    
    var starRating: Int {
        guard totalQuestions > 0 else { return 0 }
        let stars = Double(bestScore) / Double(totalQuestions) * 5.0
        return Int(round(stars))
    }
} 

