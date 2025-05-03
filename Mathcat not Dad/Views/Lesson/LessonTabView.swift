import SwiftUI

struct LessonTabView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @EnvironmentObject private var lessonVM: LessonVM
    @State private var showProfile = false
    @State private var showQuestions = false
    
    var body: some View {
        NavigationView {
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
                                    },
                                    onNext: lessonVM.nextQuestion
                                )
                            } else {
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
                                    }
                                )
                            }
                        }
                    }
                }
                .padding()
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