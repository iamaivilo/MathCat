import SwiftUI

class LessonVM: ObservableObject {
    @Published var currentLesson: LessonItem?
    @Published var lessonsForCurrentGrade: [LessonItem] = []
    @Published var completedTopics: [String] = []
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int?
    @Published var showAnswer = false
    @Published var quizQuestions: [LessonItem.Question] = []
    @Published var quizScore = 0
    @Published var showConfetti = false
    @Published var practiceAnswers: [Int?] = []
    
    private var lessons: [LessonItem] = []
    @AppStorage("completedTopics") private var completedTopicsData: Data = Data()
    
    init() {
        loadLessons()
        loadCompletedTopics()
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
    
    private func loadCompletedTopics() {
        if let decoded = try? JSONDecoder().decode([String].self, from: completedTopicsData) {
            completedTopics = decoded
        }
    }
    
    private func saveCompletedTopics() {
        if let encoded = try? JSONEncoder().encode(completedTopics) {
            completedTopicsData = encoded
        }
    }
    
    func markTopicCompleted(grade: Int, topic: String) {
        let topicId = "\(grade)_\(topic)"
        if !completedTopics.contains(topicId) {
            completedTopics.append(topicId)
            saveCompletedTopics()
        }
    }
    
    func isTopicCompleted(grade: Int, topic: String) -> Bool {
        let topicId = "\(grade)_\(topic)"
        return completedTopics.contains(topicId)
    }
    
    func getCompletedTopicsCount(for grade: Int) -> Int {
        return completedTopics.filter { $0.starts(with: "\(grade)_") }.count
    }
    
    func loadLesson(for grade: Grade) {
        // Get all lessons for this grade
        lessonsForCurrentGrade = lessons.filter { $0.grade == grade.rawValue }
        
        // Find the first uncompleted topic or default to the first one
        if let firstUncompleted = lessonsForCurrentGrade.first(where: { !isTopicCompleted(grade: $0.grade, topic: $0.topic) }) {
            currentLesson = firstUncompleted
        } else if !lessonsForCurrentGrade.isEmpty {
            currentLesson = lessonsForCurrentGrade[0]
        } else {
            currentLesson = nil
        }
        
        resetQuestionState()
    }
    
    func selectLesson(topic: String) {
        currentLesson = lessonsForCurrentGrade.first { $0.topic == topic }
        resetQuestionState()
    }
    
    private func resetQuestionState() {
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
        if let lesson = currentLesson, quizScore == quizQuestions.count {
            markTopicCompleted(grade: lesson.grade, topic: lesson.topic)
        }
    }
    
    func practiceScore() -> Int {
        guard let lesson = currentLesson else { return 0 }
        return lesson.mcq.enumerated().filter { idx, q in
            practiceAnswers.indices.contains(idx) && practiceAnswers[idx] == q.answer
        }.count
    }
} 