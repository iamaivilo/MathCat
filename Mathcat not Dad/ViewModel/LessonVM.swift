import SwiftUI

class LessonVM: ObservableObject {
    @Published var currentLesson: LessonItem?
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int?
    @Published var showAnswer = false
    @Published var quizQuestions: [LessonItem.Question] = []
    @Published var quizScore = 0
    @Published var showConfetti = false
    @Published var practiceAnswers: [Int?] = []
    
    private var lessons: [LessonItem] = []
    
    init() {
        loadLessons()
    }
    
    private func loadLessons() {
        guard let url = Bundle.main.url(forResource: "lessons", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([GradeLesson].self, from: data) else {
            return
        }
        
        lessons = decoded.map { gradeLesson in
            LessonItem(
                grade: gradeLesson.grade,
                topic: gradeLesson.topic,
                lessonMarkdown: gradeLesson.lessonMarkdown,
                mcq: gradeLesson.mcq,
                quizBank: gradeLesson.quizBank
            )
        }
    }
    
    func loadLesson(for grade: Grade) {
        currentLesson = lessons.first { $0.grade == grade.rawValue }
        currentQuestionIndex = 0
        selectedAnswer = nil
        showAnswer = false
        practiceAnswers = Array(repeating: nil, count: currentLesson?.mcq.count ?? 0)
    }
    
    func selectAnswer(_ index: Int) {
        selectedAnswer = index
        showAnswer = true
        if currentQuestionIndex < practiceAnswers.count {
            practiceAnswers[currentQuestionIndex] = index
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < (currentLesson?.mcq.count ?? 0) - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showAnswer = false
        }
    }
    
    func startQuiz() {
        guard let lesson = currentLesson else { return }
        quizQuestions = Array(lesson.quizBank.shuffled().prefix(5))
        quizScore = 0
        showConfetti = false
    }
    
    func submitQuizAnswer(_ index: Int, for question: LessonItem.Question) {
        if index == question.answer {
            quizScore += 1
        }
    }
    
    func finishQuiz() {
        showConfetti = true
    }
    
    func practiceScore() -> Int {
        guard let lesson = currentLesson else { return 0 }
        return lesson.mcq.enumerated().filter { idx, q in
            practiceAnswers.indices.contains(idx) && practiceAnswers[idx] == q.answer
        }.count
    }
} 