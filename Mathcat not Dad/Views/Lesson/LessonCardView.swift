import SwiftUI

struct LessonCardView: View {
    let lesson: LessonItem
    var onStartQuestions: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lesson.topic)
                .font(.title)
                .bold()
            
            Text(lesson.lessonMarkdown)
                .font(.body)
            
            if let onStartQuestions = onStartQuestions {
                Button(action: onStartQuestions) {
                    Text("Start Questions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(12)
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