import SwiftUI

/// A static header strip displayed at the top of the login screen.
///
/// Shows a lock icon and the Okta tenant domain on the left, and the Okta
/// logo on the right. A thin bottom divider visually separates the header
/// from the form area below.
struct OktaHeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Lock icon + tenant domain
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                    Text("acmebank.okta.com")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }

                Spacer()

                // Okta branding
                OktaLogoView(size: 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))

            Divider()
        }
    }
}

// MARK: - Preview

#Preview {
    OktaHeaderView()
}
