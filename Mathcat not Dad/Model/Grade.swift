import Foundation

enum Grade: Int, CaseIterable, Identifiable, Codable {
    case k = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .k: return "Kindergarten"
        default: return "Grade \(rawValue)"
        }
    }
    
    var shortName: String {
        switch self {
        case .k: return "K"
        default: return "\(rawValue)"
        }
    }
} 