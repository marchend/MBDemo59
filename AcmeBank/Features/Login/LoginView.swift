import SwiftUI
import SafariServices

// MARK: - SafariView (UIViewControllerRepresentable wrapper)

/// A thin `UIViewControllerRepresentable` wrapper around `SFSafariViewController`
/// so we can present Safari modally from a SwiftUI sheet.
private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - LoginView

/// The primary login screen for AcmeBank.
///
/// Assembles the branded header, form fields, error banner, and footer sub-views
/// and delegates all mutable state to `LoginViewModel`.
///
/// **Composition root wiring:** this view is presented as the initial scene content
/// from `AcmeBankApp.swift`. It is not reached via a sheet or navigation push.
struct LoginView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel: LoginViewModel

    // MARK: - Sheet state

    @State private var isHelpSheetPresented = false
    @State private var isOpenAccountSheetPresented = false

    // MARK: - Init

    /// Creates a `LoginView`.
    ///
    /// - Parameter onSignIn: Forwarded verbatim to `LoginViewModel`; called when
    ///   the user taps Sign In with valid credentials. Defaults to a no-op so the
    ///   view can be instantiated in unit tests and Xcode Previews without a handler.
    init(onSignIn: @escaping (String, String, Bool) -> Void = { _, _, _ in }) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(onSignIn: onSignIn))
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ─────────────────────────────────────────────────────
            OktaHeaderView()

            // ── Scrollable form area ───────────────────────────────────────
            ScrollView {
                VStack(spacing: 24) {
                    logoSection
                    formSection
                    optionsSection
                    signInButton
                    openAccountRow
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 24)
            }

            Spacer(minLength: 0)

            // ── Footer ─────────────────────────────────────────────────────
            SecuredByOktaFooterView()
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $isHelpSheetPresented) {
            SafariView(url: URL(string: "https://help.okta.com")!)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isOpenAccountSheetPresented) {
            PlaceholderAccountCreationView()
        }
    }

    // MARK: - Sub-sections

    /// Hexagonal logo + title + subtitle.
    private var logoSection: some View {
        VStack(spacing: 12) {
            HexagonLogoView(size: 64)

            Text("Acme Bank")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.acmeNavy)

            Text("Sign in to your account")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }

    /// Username and password fields plus the error banner.
    private var formSection: some View {
        VStack(spacing: 12) {
            // Username field
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.primary)

                TextField("Username", text: $viewModel.username)
                    .font(.body)
                    .textContentType(.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    }
                    .accessibilityIdentifier("usernameField")
            }

            // Password field
            VStack(alignment: .leading, spacing: 4) {
                Text("Password")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.primary)

                PasswordFieldView(
                    text: $viewModel.password,
                    isVisible: $viewModel.isPasswordVisible
                )
                .accessibilityIdentifier("passwordField")
            }

            // Error banner (hidden when errorMessage is nil)
            ErrorBannerView(message: viewModel.errorMessage)
                .accessibilityIdentifier("errorBanner")
        }
    }

    /// "Keep me signed in" toggle and "Need help?" button.
    private var optionsSection: some View {
        HStack {
            // iOS toggle styled inline (iOS does not support .checkbox toggleStyle)
            HStack(spacing: 8) {
                Button {
                    viewModel.keepSignedIn.toggle()
                } label: {
                    Image(systemName: viewModel.keepSignedIn
                          ? "checkmark.square.fill"
                          : "square")
                        .foregroundStyle(viewModel.keepSignedIn
                                         ? Color.acmeNavy
                                         : Color.secondary)
                        .font(.body)
                }
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
                .accessibilityValue(viewModel.keepSignedIn ? "checked" : "unchecked")
                .accessibilityIdentifier("keepSignedInToggle")

                Text("Keep me signed in")
                    .font(.subheadline)
                    .foregroundStyle(Color.primary)
                    .onTapGesture { viewModel.keepSignedIn.toggle() }
            }

            Spacer()

            Button {
                isHelpSheetPresented = true
            } label: {
                Text("Need help?")
                    .font(.subheadline)
                    .foregroundStyle(Color.acmeNavy)
                    .underline()
            }
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
            .accessibilityIdentifier("needHelpButton")
        }
    }

    /// Full-width "Sign in" button; disabled when both fields are not populated.
    private var signInButton: some View {
        Button {
            viewModel.signIn()
        } label: {
            Text("Sign in")
                .font(.headline)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, minHeight: 50)
        }
        .background(Color.acmeNavy)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .disabled(!viewModel.isSignInEnabled)
        .opacity(viewModel.isSignInEnabled ? 1.0 : 0.5)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isSignInEnabled)
        .accessibilityIdentifier("signInButton")
    }

    /// "Don't have an account? Open one." link row.
    private var openAccountRow: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)

            Button {
                isOpenAccountSheetPresented = true
            } label: {
                Text("Open one.")
                    .font(.subheadline)
                    .foregroundStyle(Color.acmeNavy)
                    .underline()
            }
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
            .accessibilityIdentifier("openAccountButton")
        }
    }
}

// MARK: - Preview

#Preview("Default — empty fields") {
    LoginView()
}

#Preview("Both fields populated") {
    LoginView()
}
