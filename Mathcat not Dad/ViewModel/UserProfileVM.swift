import SwiftUI

class UserProfileVM: ObservableObject {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("avatar") var avatar: String = "😺"
    @AppStorage("selectedGrade") var selectedGrade: Int = 0
    @AppStorage("quizResults") private var quizResultsData: Data = Data()
    @AppStorage("treats") var treats: Int = 0
    @AppStorage("purchasedIcons") var purchasedIcons: String = ""
    @AppStorage("lastGameDate") var lastGameDate: Double = 0 // TimeInterval since 1970
    
    @Published var quizResults: [QuizResult] = []
    
    var purchasedIconList: [String] {
        purchasedIcons.split(separator: ",").map { String($0) }
    }
    
    func addTreats(_ amount: Int) {
        treats += amount
    }
    
    func purchaseIcon(_ icon: String, cost: Int) -> Bool {
        guard treats >= cost else { return false }
        if !purchasedIconList.contains(icon) {
            treats -= cost
            let updated = (purchasedIconList + [icon]).joined(separator: ",")
            purchasedIcons = updated
            return true
        }
        return false
    }
    
    func hasPurchased(_ icon: String) -> Bool {
        purchasedIconList.contains(icon)
    }
    
    func canPlayGameToday() -> Bool {
        let now = Date().timeIntervalSince1970
        let oneDay: Double = 60 * 60 * 24
        return now - lastGameDate > oneDay
    }
    
    func markGamePlayed() {
        lastGameDate = Date().timeIntervalSince1970
    }
    
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