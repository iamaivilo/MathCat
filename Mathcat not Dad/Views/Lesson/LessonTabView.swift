import SwiftUI

struct LessonTabView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @EnvironmentObject private var lessonVM: LessonVM
    @State private var showProfile = false
    @State private var showQuestions = false
    @State private var showPracticeResult = false
    @State private var showQuiz = false
    @State private var showQuizResult = false
    @State private var quizCompleted = false
    @State private var selectedTopic: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        if showQuizResult {
                            // Only show result, not lesson card
                            let correct = lessonVM.quizScore
                            let total = lessonVM.quizQuestions.count
                            let stars = Int(round(Double(correct) / Double(max(total,1)) * 5.0))
                            VStack(spacing: 24) {
                                Text("Quiz Complete! 🎉")
                                    .font(.title2)
                                    .bold()
                                Text("You got \(correct) out of \(total) correct!")
                                    .font(.title3)
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { i in
                                        Image(systemName: i < stars ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                    }
                                }
                                Button(action: {
                                    showQuizResult = false
                                    quizCompleted = true
                                    selectedTopic = nil
                                }) {
                                    Text("Back to Lessons")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.primary)
                                        .cornerRadius(12)
                                }
                            }
                        } else if showPracticeResult {
                            if let lesson = lessonVM.currentLesson {
                                let correct = lessonVM.practiceScore()
                                let total = lesson.mcq.count
                                let stars = Int(round(Double(correct) / Double(max(total,1)) * 5.0))
                                VStack(spacing: 24) {
                                    Text("You got \(correct) out of \(total) correct!")
                                        .font(.title2)
                                        .bold()
                                    HStack(spacing: 4) {
                                        ForEach(0..<5) { i in
                                            Image(systemName: i < stars ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    Button(action: {
                                        showPracticeResult = false
                                        lessonVM.startQuiz()
                                        showQuiz = true
                                    }) {
                                        Text("Start Final Quiz")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.primary)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        } else if showQuiz {
                            QuizView(
                                questions: lessonVM.quizQuestions,
                                score: lessonVM.quizScore,
                                showConfetti: lessonVM.showConfetti,
                                onSubmitAnswer: { index, question in
                                    lessonVM.submitQuizAnswer(index, for: question)
                                },
                                onFinish: {
                                    lessonVM.finishQuiz()
                                    if let lesson = lessonVM.currentLesson {
                                        userProfileVM.saveQuizResult(
                                            grade: Grade(rawValue: lesson.grade) ?? .k,
                                            score: lessonVM.quizScore,
                                            totalQuestions: lessonVM.quizQuestions.count
                                        )
                                    }
                                    showQuiz = false
                                    showQuizResult = true
                                }
                            )
                        } else if showQuestions {
                            if let lesson = lessonVM.currentLesson, lessonVM.currentQuestionIndex < lesson.mcq.count {
                                QuestionView(
                                    question: lesson.mcq[lessonVM.currentQuestionIndex],
                                    selectedAnswer: $lessonVM.selectedAnswer,
                                    showAnswer: $lessonVM.showAnswer,
                                    isLastQuestion: lessonVM.currentQuestionIndex == lesson.mcq.count - 1,
                                    onAnswerSelected: { index in
                                        lessonVM.selectAnswer(index)
                                        if lessonVM.currentQuestionIndex == lesson.mcq.count - 1 {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                let correct = lessonVM.practiceScore()
                                                userProfileVM.saveQuizResult(
                                                    grade: Grade(rawValue: lesson.grade) ?? .k,
                                                    score: correct,
                                                    totalQuestions: lesson.mcq.count
                                                )
                                                showQuestions = false
                                                showPracticeResult = true
                                            }
                                        }
                                    },
                                    onNext: {
                                        lessonVM.nextQuestion()
                                    }
                                )
                            }
                        } else {
                            // Show cat topic list
                            ForEach(lessonVM.lessonsForCurrentGrade) { lesson in
                                let isCompleted = lessonVM.isTopicCompleted(grade: lesson.grade, topic: lesson.topic)
                                let isExpanded = selectedTopic == lesson.topic
                                let canAccess = canAccessLesson(lesson)
                                
                                CatTopicRow(
                                    topic: lesson.topic,
                                    isCompleted: isCompleted,
                                    isExpanded: isExpanded,
                                    isLocked: !canAccess,
                                    onTap: {
                                        if canAccess {
                                            if isExpanded {
                                                selectedTopic = nil
                                            } else {
                                                selectedTopic = lesson.topic
                                                lessonVM.selectLesson(topic: lesson.topic)
                                            }
                                        }
                                    }
                                )
                                
                                if isExpanded {
                                    LessonCardView(
                                        lesson: lesson,
                                        onStartQuestions: { 
                                            showQuestions = true 
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Grade \(Grade(rawValue: userProfileVM.selectedGrade)?.shortName ?? "K") 🐱")
            .sheet(isPresented: $showProfile) {
                ProfileTabView()
            }
            .onAppear {
                // Reset lesson view state
                selectedTopic = nil
                showQuestions = false
                showPracticeResult = false
                showQuizResult = false
            }
        }
    }
    
    // Helper to determine if a lesson is accessible
    private func canAccessLesson(_ lesson: LessonItem) -> Bool {
        if lessonVM.isTopicCompleted(grade: lesson.grade, topic: lesson.topic) {
            return true
        }
        
        // Get the first uncompleted lesson
        let uncompletedLessons = lessonVM.lessonsForCurrentGrade.filter { 
            !lessonVM.isTopicCompleted(grade: $0.grade, topic: $0.topic) 
        }
        
        return uncompletedLessons.first?.topic == lesson.topic
    }
}

// Cat topic row view
struct CatTopicRow: View {
    let topic: String
    let isCompleted: Bool
    let isExpanded: Bool
    let isLocked: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(catEmoji)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading) {
                    Text(topic)
                        .font(.headline)
                    
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundColor(statusColor)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: 2)
            )
            .opacity(isLocked ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLocked)
        .padding(.vertical, 5)
    }
    
    private var catEmoji: String {
        if isCompleted {
            return "😻"  // Completed
        } else if isLocked {
            return "🙀"  // Locked
        } else {
            return "😺"  // Available
        }
    }
    
    private var statusText: String {
        if isCompleted {
            return "Completed!"
        } else if isLocked {
            return "Complete previous topic first"
        } else {
            return "Available to start"
        }
    }
    
    private var statusColor: Color {
        if isCompleted {
            return .green
        } else if isLocked {
            return .gray
        } else {
            return .blue
        }
    }
    
    private var backgroundColor: Color {
        if isCompleted {
            return Color.green.opacity(0.1)
        } else if isLocked {
            return Color.gray.opacity(0.1)
        } else {
            return Color.yellow.opacity(0.2)
        }
    }
    
    private var borderColor: Color {
        if isCompleted {
            return .green
        } else if isLocked {
            return .gray
        } else {
            return .orange
        }
    }
} 