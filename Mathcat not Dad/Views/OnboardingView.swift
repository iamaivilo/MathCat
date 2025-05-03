import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @State private var name = ""
    @State private var selectedEmoji = "😺"
    @State private var selectedGrade = Grade.k
    
    private let emojis = ["😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "😺‍👓", "😺‍🚀"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Welcome to MathCat! 🐱")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Let's get you started with some quick setup.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's your name?")
                            .font(.headline)
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose your cat avatar")
                            .font(.headline)
                        
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
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select your grade")
                            .font(.headline)
                        
                        Picker("Grade", selection: $selectedGrade) {
                            ForEach(Grade.allCases) { grade in
                                Text(grade.displayName)
                                    .tag(grade)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding(.horizontal)
                    
                    Button(action: saveProfile) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(name.isEmpty)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveProfile() {
        userProfileVM.userName = name
        userProfileVM.avatar = selectedEmoji
        userProfileVM.selectedGrade = selectedGrade.rawValue
    }
} 