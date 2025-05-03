import SwiftUI

struct QuizView: View {
    let questions: [LessonItem.Question]
    let score: Int
    let showConfetti: Bool
    let onSubmitAnswer: (Int, LessonItem.Question) -> Void
    let onFinish: () -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showAnswer = false
    
    var body: some View {
        VStack(spacing: 24) {
            if currentQuestionIndex < questions.count {
                QuestionView(
                    question: questions[currentQuestionIndex],
                    selectedAnswer: $selectedAnswer,
                    showAnswer: $showAnswer,
                    isLastQuestion: currentQuestionIndex == questions.count - 1,
                    onAnswerSelected: { index in
                        onSubmitAnswer(index, questions[currentQuestionIndex])
                        showAnswer = true
                        if currentQuestionIndex == questions.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                onFinish()
                            }
                        }
                    },
                    onNext: {
                        currentQuestionIndex += 1
                        selectedAnswer = nil
                        showAnswer = false
                        
                        if currentQuestionIndex == questions.count {
                            onFinish()
                        }
                    }
                )
            } else {
                VStack(spacing: 24) {
                    Text("Quiz Complete! 🎉")
                        .font(.title)
                        .bold()
                    
                    Text("Your score: \(score)/\(questions.count)")
                        .font(.title2)
                    
                    if showConfetti {
                        ConfettiView()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 8)
                )
            }
        }
    }
}

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 50
        cell.lifetime = 3
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scale = 0.5
        cell.scaleRange = 0.25
        cell.contents = UIImage(systemName: "star.fill")?.cgImage
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
} 