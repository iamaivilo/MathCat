import SwiftUI

struct GameTabView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @State private var showTreatGame = false
    @State private var showGroomingGame = false
    @State private var showCatHouse = false
    
    var body: some View {
        VStack(spacing: 24) {
            if !userProfileVM.canPlayGameToday() {
                Text("You've finished today's game, come back tomorrow!")
                    .font(.headline)
                    .foregroundColor(.purple)
                    .padding(.top, 16)
            }
            HStack(spacing: 20) {
                GameCardView(
                    title: "Cat Treat",
                    icon: "🍬",
                    color: .orange,
                    disabled: !userProfileVM.canPlayGameToday(),
                    action: { showTreatGame = true }
                )
                GameCardView(
                    title: "Cat Grooming",
                    icon: "🧼",
                    color: .blue,
                    disabled: !userProfileVM.canPlayGameToday(),
                    action: { showGroomingGame = true }
                )
                GameCardView(
                    title: "Cat House",
                    icon: "🏠",
                    color: .green,
                    disabled: false,
                    action: { showCatHouse = true }
                )
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showTreatGame) {
            CatTreatGameView()
        }
        .sheet(isPresented: $showGroomingGame) {
            CatGroomingGameView()
        }
        .sheet(isPresented: $showCatHouse) {
            CatHouseView()
        }
    }
}

struct GameCardView: View {
    let title: String
    let icon: String
    let color: Color
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: { if !disabled { action() } }) {
            VStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 40))
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(width: 100, height: 120)
            .background(disabled ? Color.gray.opacity(0.2) : color.opacity(0.2))
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(disabled ? Color.gray : color, lineWidth: 2)
            )
            .opacity(disabled ? 0.5 : 1.0)
        }
        .disabled(disabled)
    }
} 