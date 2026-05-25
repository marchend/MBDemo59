import SwiftUI

/// Reusable Okta logo mark.
///
/// Rendered as an SF Symbol placeholder (`lock.shield.fill`) tinted in the
/// Okta brand blue. When a real Okta logo asset is added to `Assets.xcassets`
/// this view can be updated to use `Image("okta-logo")` without touching call
/// sites.
struct OktaLogoView: View {
    /// Controls the rendered size of the logo. Defaults to 20 pt.
    var size: CGFloat = 20

    var body: some View {
        // The Okta wordmark is approximated by the text "okta" in a bold,
        // rounded system font tinted in Okta's brand colour.
        Text("okta")
            .font(.system(size: size * 0.85, weight: .bold, design: .rounded))
            .foregroundStyle(Color(hex: "#007DC1")) // Okta brand blue
            .accessibilityHidden(true) // decorative, label context provided by parent
    }
}

// MARK: - Preview

#Preview {
    OktaLogoView()
        .padding()
}
