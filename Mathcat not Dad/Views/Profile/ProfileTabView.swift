import SwiftUI

struct ProfileTabView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @EnvironmentObject private var lessonVM: LessonVM
    @Environment(\.dismiss) private var dismiss
    @State private var showEmojiPicker = false
    @State private var showGradePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text(userProfileVM.avatar)
                            .font(.system(size: 80))
                            .frame(width: 120, height: 120)
                            .background(
                                Circle()
                                    .fill(Color.primary.opacity(0.1))
                            )
                        
                        TextField("Your name", text: $userProfileVM.userName)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 8)
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.title2)
                            .bold()
                        
                        Button(action: { showEmojiPicker = true }) {
                            HStack {
                                Text("Change Avatar")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 4)
                            )
                        }
                        
                        Button(action: { showGradePicker = true }) {
                            HStack {
                                Text("Change Grade")
                                Spacer()
                                Text(Grade(rawValue: userProfileVM.selectedGrade)?.displayName ?? "K")
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 4)
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Progress")
                            .font(.title2)
                            .bold()
                        
                        ForEach(Grade.allCases) { grade in
                            let completedTopicsCount = lessonVM.getCompletedTopicsCount(for: grade.rawValue)
                            HStack {
                                Text(grade.displayName)
                                Spacer()
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < grade.getStarRating(completedTopicsCount: completedTopicsCount) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 4)
                            )
                        }
                    }
                    
                    Button(action: {
                        userProfileVM.resetProgress()
                        lessonVM.completedTopics = []
                        lessonVM.loadLesson(for: Grade(rawValue: userProfileVM.selectedGrade) ?? .k)
                    }) {
                        Text("Reset Progress")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.1))
                            )
                    }
                    
                    // Reset Games Button (resets treats, purchased items, and daily limit)
                    Button(action: userProfileVM.resetGames) {
                        Text("Reset Games")
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.1))
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showEmojiPicker) {
                let defaultEmojis = ["😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "😺‍👓", "😺‍🚀"]
                let purchased = userProfileVM.purchasedIconList
                let extraIcons = purchased.filter { !defaultEmojis.contains($0) }
                let allAvatars = defaultEmojis + extraIcons
                EmojiPickerSheet(selectedEmoji: $userProfileVM.avatar, availableEmojis: allAvatars)
            }
            .sheet(isPresented: $showGradePicker) {
                GradePickerSheet(selectedGrade: $userProfileVM.selectedGrade)
            }
        }
    }
} 