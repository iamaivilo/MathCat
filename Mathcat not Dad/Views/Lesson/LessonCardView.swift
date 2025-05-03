import SwiftUI

struct LessonCardView: View {
    let lesson: LessonItem
    var onStartQuestions: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(lesson.topic)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 4)
                .foregroundColor(.primary)
            
            Divider()
                .padding(.vertical, 2)
            
            Text(.init(lesson.lessonMarkdown))
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 8)
            
            if let onStartQuestions = onStartQuestions {
                Button(action: onStartQuestions) {
                    Text("Start Questions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(16)
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
} 