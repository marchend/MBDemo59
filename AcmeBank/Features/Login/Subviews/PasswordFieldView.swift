import SwiftUI

/// A password input field with a reveal/hide toggle.
///
/// Renders as a `SecureField` when the password is hidden, and as a
/// plain `TextField` when revealed. The toggle button uses the SF Symbol
/// `eye` / `eye.slash` to communicate the current visibility state.
struct PasswordFieldView: View {
    /// The password string binding shared with the parent form.
    @Binding var text: String
    /// Whether the password is currently visible in plain text.
    @Binding var isVisible: Bool
    /// Placeholder label shown when the field is empty.
    var placeholder: String = "Password"

    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .textContentType(.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                }
            }
            .font(.body)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundStyle(Color.secondary)
            }
            .buttonStyle(.plain)
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
            .accessibilityLabel(isVisible ? "Hide password" : "Show password")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        PasswordFieldView(text: .constant(""), isVisible: .constant(false))
        PasswordFieldView(text: .constant("secret"), isVisible: .constant(true))
    }
    .padding()
}
