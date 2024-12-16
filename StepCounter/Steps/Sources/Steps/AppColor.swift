import SwiftUI

public enum AppColor: String {
    case blue = "Blue"
    case green = "Green"
    case red = "Red"
    case orange = "Orange"
    case purple = "Purple"

    private func toColor() -> Color {
        switch self {
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .purple:
            return Color.purple
        }
    }

    public static func color(from string: String) -> Color {
        return AppColor(rawValue: string)?.toColor() ?? Color.gray
    }
}
