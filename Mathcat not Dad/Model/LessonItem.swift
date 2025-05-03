import Foundation

struct LessonItem: Codable, Identifiable {
    let id = UUID()
    let grade: Int
    let topic: String
    let lessonMarkdown: String
    let mcq: [Question]
    let quizBank: [Question]
    
    struct Question: Codable, Identifiable {
        let id = UUID()
        let q: String
        let choices: [String]
        let answer: Int
    }
}

// MARK: - GradeLesson
struct GradeLesson: Codable {
    let grade: Int
    let topic: String
    let lessonMarkdown: String
    let mcq: [LessonItem.Question]
    let quizBank: [LessonItem.Question]
} 