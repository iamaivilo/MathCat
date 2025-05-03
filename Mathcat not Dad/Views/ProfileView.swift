import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    
    var body: some View {
        VStack(spacing: 20) {
            Text(userProfileVM.avatar)
                .font(.system(size: 80))
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                )
            
            Text(userProfileVM.userName)
                .font(.title2)
                .bold()
            
            Text("Grade \(Grade(rawValue: userProfileVM.selectedGrade)?.displayName ?? "K")")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Progress")
                    .font(.title3)
                    .bold()
                
                ForEach(Grade.allCases) { grade in
                    HStack {
                        Text(grade.displayName)
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < (userProfileVM.quizResults.first { $0.grade == grade }?.starRating ?? 0) ? "star.fill" : "star")
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
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Treats: \(userProfileVM.treats)")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                if !userProfileVM.purchasedIconList.isEmpty {
                    Text("Purchased Items:")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(userProfileVM.purchasedIconList, id: \.self) { icon in
                                Text(icon)
                                    .font(.system(size: 30))
                                    .padding(8)
                                    .background(
                                        Circle()
                                            .stroke(Color.purple, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Reset Progress Button (resets only lesson progress)
            Button(action: userProfileVM.resetProgress) {
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
            
            // TESTING BUTTON - REMOVE BEFORE PRODUCTION
            // This button resets everything for testing purposes
            // To remove: Delete this entire Button block
            Button("Reset Everything (Testing Only)") {
                userProfileVM.resetAppState()
            }
            .font(.caption)
            .foregroundColor(.red)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
    }
} 
