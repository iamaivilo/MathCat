import SwiftUI

struct TabRootView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @EnvironmentObject private var lessonVM: LessonVM
    
    var body: some View {
        TabView {
            LessonTabView()
                .tabItem {
                    Label("Lesson", systemImage: "book.fill")
                }
            
            GameTabView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller.fill")
                }
            
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .onAppear {
            lessonVM.loadLesson(for: Grade(rawValue: userProfileVM.selectedGrade) ?? .k)
        }
        .onChange(of: userProfileVM.selectedGrade) { newGrade in
            lessonVM.loadLesson(for: Grade(rawValue: newGrade) ?? .k)
        }
    }
} 