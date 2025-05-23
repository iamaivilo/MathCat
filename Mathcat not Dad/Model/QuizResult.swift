import Foundation

struct QuizResult: Codable, Identifiable {
    let id = UUID()
    let grade: Grade
    let bestScore: Int
    let totalQuestions: Int
    
    var starRating: Int {
        // This will be replaced by the completedTopicsCount approach
        guard totalQuestions > 0 else { return 0 }
        let stars = Double(bestScore) / Double(totalQuestions) * 5.0
        return Int(round(stars))
    }
}

// Extension to compute star rating from completed topics
extension Grade {
    func getStarRating(completedTopicsCount: Int) -> Int {
        // Each completed topic is worth 1 star, max 5 stars
        return min(completedTopicsCount, 5)
    }
} 

 