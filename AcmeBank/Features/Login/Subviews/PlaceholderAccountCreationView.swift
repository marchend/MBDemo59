import SwiftUI

/// A placeholder destination for the "Don't have an account? Open one" link.
///
/// This is a stub that will be replaced with a real account-creation flow in a
/// future PR. It exists so the link is functional and does not crash.
struct PlaceholderAccountCreationView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 48))
                .foregroundStyle(Color.acmeNavy)

            Text("Coming soon")
                .font(.headline)
                .foregroundStyle(Color.primary)

            Text("Account creation will be available in a future update.")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Preview

#Preview {
    PlaceholderAccountCreationView()
}
