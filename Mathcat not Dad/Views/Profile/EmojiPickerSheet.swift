import SwiftUI

struct EmojiPickerSheet: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    
    private let emojis = ["😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "😺‍👓", "😺‍🚀"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 40))
                            .frame(width: 60, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedEmoji == emoji ? Color.primary.opacity(0.1) : Color.clear)
                            )
                            .onTapGesture {
                                selectedEmoji = emoji
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 