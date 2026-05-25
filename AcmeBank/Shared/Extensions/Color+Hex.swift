import SwiftUI

extension Color {
    /// Creates a `Color` from a hexadecimal string.
    ///
    /// Accepts strings with or without a leading `#`. Supports 6-digit RGB
    /// and 8-digit RGBA hex values. Falls back to `Color.clear` for invalid
    /// inputs.
    ///
    /// ```swift
    /// let navy = Color(hex: "#1B2A4A")
    /// let semiTransparent = Color(hex: "FF0000AA")
    /// ```
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r, g, b, a: Double
        switch hexSanitized.count {
        case 6:
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8)  / 255.0
            b = Double(rgb & 0x0000FF)          / 255.0
            a = 1.0
        case 8:
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8)  / 255.0
            a = Double(rgb & 0x000000FF)          / 255.0
        default:
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    // MARK: - AcmeBank Design Tokens

    /// AcmeBank primary navy — `#1B2A4A`.
    static let acmeNavy = Color(hex: "#1B2A4A")
}
