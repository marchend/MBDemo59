import SwiftUI

// MARK: - HexagonShape

/// A flat-top hexagon `Shape` for use in SwiftUI.
private struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let cx = rect.midX
        let cy = rect.midY

        // Six vertices of a flat-top hexagon, starting from the right vertex
        // and going clockwise. Using the inscribed-circle radius so the shape
        // fills the bounding rect as tightly as possible.
        let rx = width / 2.0
        let ry = height / 2.0
        let points: [CGPoint] = (0..<6).map { i in
            let angle = CGFloat(i) * .pi / 3.0 - .pi / 6.0
            return CGPoint(
                x: cx + rx * cos(angle),
                y: cy + ry * sin(angle)
            )
        }

        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - HexagonLogoView

/// Navy hexagon with a white bold "A" centred inside.
///
/// Used as the AcmeBank brand mark on the login screen.
struct HexagonLogoView: View {
    /// Side length (width and height) of the hexagon bounding box. Defaults to
    /// 56 pt to match the login-screen mockup.
    var size: CGFloat = 56

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(Color.acmeNavy)
                .frame(width: size, height: size)

            Text("A")
                .font(.system(size: size * 0.45, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true) // decorative; not meaningful to VoiceOver
    }
}

// MARK: - Preview

#Preview {
    HexagonLogoView()
        .padding()
}
