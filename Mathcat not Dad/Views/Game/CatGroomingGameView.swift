import SwiftUI

struct CatGroomingGameView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion = 0
    @State private var correctCount = 0
    @State private var timeLeft = 60
    @State private var showResult = false
    @State private var record: Int = 0
    @State private var questions: [LessonItem.Question] = []
    @State private var selected: Int? = nil
    @State private var showAnswer = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            if showResult {
                VStack(spacing: 24) {
                    Text("Cat Grooming! 🧼")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("You groomed \(correctCount) cats!")
                        .font(.title2)
                        .foregroundColor(.white)
                    HStack(spacing: 8) {
                        ForEach(0..<correctCount, id: \.self) { _ in
                            Text("🐱")
                                .font(.system(size: 32))
                        }
                    }
                    Text("You earned \(correctCount * 2) treats!")
                        .font(.headline)
                        .foregroundColor(.yellow)
                    Button("Next") {
                        dismiss()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.purple)
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.purple.ignoresSafeArea())
            } else {
                VStack(spacing: 16) {
                    Text("Time Left: \(timeLeft)s")
                        .font(.headline)
                        .foregroundColor(.purple)
                    if currentQuestion < questions.count {
                        Text(questions[currentQuestion].q)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                        ForEach(Array(questions[currentQuestion].choices.enumerated()), id: \.offset) { idx, choice in
                            Button(action: {
                                if !showAnswer {
                                    selected = idx
                                    showAnswer = true
                                    if idx == questions[currentQuestion].answer {
                                        correctCount += 1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        nextQ()
                                    }
                                }
                            }) {
                                HStack {
                                    Text(choice)
                                        .font(.body)
                                    Spacer()
                                    if showAnswer && idx == questions[currentQuestion].answer {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    } else if showAnswer && idx == selected {
                                        Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(showAnswer ? (idx == questions[currentQuestion].answer ? Color.green.opacity(0.1) : (idx == selected ? Color.red.opacity(0.1) : Color.clear)) : Color.clear)
                                )
                            }
                            .disabled(showAnswer)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: startGame)
        .onDisappear { timer?.invalidate() }
    }
    
    func startGame() {
        // Use random hard questions from all grades for fun
        // For now, use dummy harder questions
        questions = (1...5).map { i in LessonItem.Question(q: "Hard Q\(i)?", choices: ["A","B","C","D"], answer: Int.random(in: 0...3)) }
        timeLeft = 60
        correctCount = 0
        currentQuestion = 0
        selected = nil
        showAnswer = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeLeft -= 1
            if timeLeft <= 0 { finishGame() }
        }
    }
    
    func nextQ() {
        showAnswer = false
        selected = nil
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            finishGame()
        }
    }
    
    func finishGame() {
        timer?.invalidate()
        showResult = true
        userProfileVM.addTreats(correctCount * 2)
        userProfileVM.markGamePlayed()
    }
} 