import SwiftUI

struct CatHouseView: View {
    @EnvironmentObject private var userProfileVM: UserProfileVM
    @Environment(\.dismiss) private var dismiss
    
    let shopIcons: [(icon: String, name: String, cost: Int)] = [
        ("🐟", "Fish", 10),
        ("🚀", "Rocket", 20),
        ("🎩", "Hat", 15),
        ("🦋", "Butterfly", 12),
        ("🌈", "Rainbow", 18),
        ("🧀", "Cheese", 8)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Cat House Shop 🏠")
                .font(.largeTitle)
                .bold()
            Text("Treats: \(userProfileVM.treats)")
                .font(.headline)
                .foregroundColor(.orange)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(shopIcons, id: \.icon) { item in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(userProfileVM.hasPurchased(item.icon) ? Color.purple : Color.gray, lineWidth: 4)
                                .frame(width: 60, height: 60)
                            Text(item.icon)
                                .font(.system(size: 36))
                        }
                        Text(item.name)
                            .font(.subheadline)
                        Text("\(item.cost) 🍬")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button(action: {
                            _ = userProfileVM.purchaseIcon(item.icon, cost: item.cost)
                        }) {
                            Text(userProfileVM.hasPurchased(item.icon) ? "Purchased" : "Buy")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(userProfileVM.hasPurchased(item.icon) ? Color.purple : (userProfileVM.treats >= item.cost ? Color.green : Color.gray))
                                .cornerRadius(10)
                        }
                        .disabled(userProfileVM.hasPurchased(item.icon) || userProfileVM.treats < item.cost)
                    }
                    .padding(8)
                }
            }
            Spacer()
            Button("Close") {
                dismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
} 