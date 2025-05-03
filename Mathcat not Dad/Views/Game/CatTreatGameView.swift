import SwiftUI

struct CatTreatGameView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion = 0
    @State private var correctCount = 0
    @State private var timeLeft = 120
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
                    Text("Cat Treats! 🍬")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("You earned \(correctCount) treats!")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Your record: \(record) treats")
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
        questions = userProfileVM.getCatTreatQuestions()
        timeLeft = 120
        correctCount = 0
        currentQuestion = 0
        selected = nil
        showAnswer = false
        record = UserDefaults.standard.integer(forKey: "catTreatRecord")
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
        userProfileVM.addTreats(correctCount)
        if correctCount > record {
            UserDefaults.standard.set(correctCount, forKey: "catTreatRecord")
        }
        userProfileVM.markGamePlayed()
    }
} 