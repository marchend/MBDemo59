import SwiftUI

/// A static footer strip displayed at the bottom of the login screen.
///
/// Shows the "Secured by" label alongside the Okta logo mark.
struct SecuredByOktaFooterView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Secured by")
                .font(.caption)
                .foregroundStyle(Color.secondary)

            OktaLogoView(size: 14)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
    }
}

// MARK: - Preview

#Preview {
    SecuredByOktaFooterView()
}
