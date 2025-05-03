import SwiftUI

class UserProfileVM: ObservableObject {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("avatar") var avatar: String = "😺"
    @AppStorage("selectedGrade") var selectedGrade: Int = 0
    @AppStorage("quizResults") private var quizResultsData: Data = Data()
    
    @Published var quizResults: [QuizResult] = []
    
    init() {
        loadQuizResults()
    }
    
    private func loadQuizResults() {
        if let decoded = try? JSONDecoder().decode([QuizResult].self, from: quizResultsData) {
            quizResults = decoded
        }
    }
    
    func saveQuizResult(grade: Grade, score: Int, totalQuestions: Int) {
        if let index = quizResults.firstIndex(where: { $0.grade == grade }) {
            if score > quizResults[index].bestScore {
                quizResults[index] = QuizResult(grade: grade, bestScore: score, totalQuestions: totalQuestions)
            }
        } else {
            quizResults.append(QuizResult(grade: grade, bestScore: score, totalQuestions: totalQuestions))
        }
        
        if let encoded = try? JSONEncoder().encode(quizResults) {
            quizResultsData = encoded
        }
    }
    
    func resetProgress() {
        quizResults = []
        quizResultsData = Data()
    }
} 