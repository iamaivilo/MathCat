import SwiftUI

struct QuestionView: View {
    let question: LessonItem.Question
    @Binding var selectedAnswer: Int?
    @Binding var showAnswer: Bool
    let isLastQuestion: Bool
    let onAnswerSelected: (Int) -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(question.q)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                ForEach(Array(question.choices.enumerated()), id: \.offset) { index, choice in
                    Button(action: {
                        if !showAnswer {
                            onAnswerSelected(index)
                        }
                    }) {
                        HStack {
                            Text(choice)
                                .font(.body)
                            
                            Spacer()
                            
                            if showAnswer {
                                if index == question.answer {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if index == selectedAnswer {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    showAnswer
                                        ? (index == question.answer
                                            ? Color.green.opacity(0.1)
                                            : (index == selectedAnswer
                                                ? Color.red.opacity(0.1)
                                                : Color.clear))
                                        : (index == selectedAnswer
                                            ? Color.primary.opacity(0.1)
                                            : Color.clear)
                                )
                        )
                    }
                    .disabled(showAnswer)
                }
            }
            
            if showAnswer {
                if !isLastQuestion {
                    Button(action: onNext) {
                        Text("Next Question")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(12)
                    }
                }
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