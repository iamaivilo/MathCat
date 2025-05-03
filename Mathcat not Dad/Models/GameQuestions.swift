import Foundation

struct GameQuestions: Codable {
    let catTreat: GameSection
    let catGrooming: GameSection
    
    struct GameSection: Codable {
        let questions: [LessonItem.Question]
    }
    
    static func load() -> GameQuestions? {
        guard let url = Bundle.main.url(forResource: "games", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let questions = try? JSONDecoder().decode(GameQuestions.self, from: data) else {
            return nil
        }
        return questions
    }
} 