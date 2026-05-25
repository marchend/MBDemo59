import SwiftUI

/// An inline error banner that is visible only when `message` is non-nil.
///
/// Use this view to surface form-validation or authentication errors to the
/// user without navigating away from the screen. The banner is hidden (zero
/// height) when `message` is `nil`.
struct ErrorBannerView: View {
    /// The error message to display. Pass `nil` to hide the banner.
    let message: String?

    var body: some View {
        if let message {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(Color.red)
                    .accessibilityHidden(true)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Color.red)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .padding(12)
            .background(Color.red.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Error: \(message)")
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ErrorBannerView(message: "Incorrect username or password. Please try again.")
        ErrorBannerView(message: nil)
    }
    .padding()
}
