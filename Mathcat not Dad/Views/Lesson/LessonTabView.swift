import SwiftUI

struct LessonTabView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @EnvironmentObject private var lessonVM: LessonVM
    @State private var showProfile = false
    @State private var showQuestions = false
    @State private var showPracticeResult = false
    @State private var showQuiz = false
    @State private var showQuizResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        if let lesson = lessonVM.currentLesson {
                            LessonCardView(lesson: lesson, onStartQuestions: { showQuestions = true })
                            
                            if showQuestions {
                                if lessonVM.currentQuestionIndex < lesson.mcq.count {
                                    QuestionView(
                                        question: lesson.mcq[lessonVM.currentQuestionIndex],
                                        selectedAnswer: $lessonVM.selectedAnswer,
                                        showAnswer: $lessonVM.showAnswer,
                                        isLastQuestion: lessonVM.currentQuestionIndex == lesson.mcq.count - 1,
                                        onAnswerSelected: { index in
                                            lessonVM.selectAnswer(index)
                                            // If this is the last question, schedule result view
                                            if lessonVM.currentQuestionIndex == lesson.mcq.count - 1 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                    let correct = lessonVM.practiceScore()
                                                    userProfileVM.saveQuizResult(
                                                        grade: Grade(rawValue: lesson.grade) ?? .k,
                                                        score: correct,
                                                        totalQuestions: lessonVM.currentLesson?.mcq.count ?? 0
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
                                } else {
                                    VStack(spacing: 24) {
                                        Text("You finished the questions! 🎉")
                                            .font(.title2)
                                            .bold()
                                        Button(action: {
                                            lessonVM.startQuiz()
                                            // Optionally, show quiz view or reset state
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
                            }
                            if showPracticeResult {
                                let correct = lessonVM.practiceScore()
                                let total = lessonVM.currentLesson?.mcq.count ?? 0
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
                            if showQuiz {
                                QuizView(
                                    questions: lessonVM.quizQuestions,
                                    score: lessonVM.quizScore,
                                    showConfetti: lessonVM.showConfetti,
                                    onSubmitAnswer: { index, question in
                                        lessonVM.submitQuizAnswer(index, for: question)
                                    },
                                    onFinish: {
                                        lessonVM.finishQuiz()
                                        userProfileVM.saveQuizResult(
                                            grade: Grade(rawValue: lesson.grade) ?? .k,
                                            score: lessonVM.quizScore,
                                            totalQuestions: lessonVM.quizQuestions.count
                                        )
                                        showQuiz = false
                                        showQuizResult = true
                                    }
                                )
                            }
                            if showQuizResult {
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
                                    }) {
                                        Text("Back to Lesson")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.primary)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Grade \(Grade(rawValue: userProfileVM.selectedGrade)?.shortName ?? "K") 🐱")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showProfile = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileTabView()
            }
        }
    }
} 