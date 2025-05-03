import SwiftUI

struct GradePickerSheet: View {
    @Binding var selectedGrade: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Picker("Grade", selection: $selectedGrade) {
                ForEach(Grade.allCases) { grade in
                    Text(grade.displayName)
                        .tag(grade.rawValue)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .navigationTitle("Select Grade")
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