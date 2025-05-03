import SwiftUI

@main
struct MathCatApp: App {
    @StateObject private var userProfileVM = UserProfileVM()
    @StateObject private var lessonVM = LessonVM()
    
    var body: some Scene {
        WindowGroup {
            if userProfileVM.userName.isEmpty {
                OnboardingView()
                    .environmentObject(userProfileVM)
            } else {
                TabRootView()
                    .environmentObject(userProfileVM)
                    .environmentObject(lessonVM)
            }
        }
    }
} 