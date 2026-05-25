import Foundation

/// ViewModel for the Login screen.
///
/// Owns all mutable UI state for the login form and exposes an `onSignIn`
/// closure that callers (coordinators, parent views) bind at construction time.
/// No SwiftUI or UIKit imports — pure business-logic layer.
final class LoginViewModel: ObservableObject {

    // MARK: - Published state

    /// The username/email field value.
    @Published var username: String = ""

    /// The password field value.
    @Published var password: String = ""

    /// Whether the password field is shown in plain text.
    @Published var isPasswordVisible: Bool = false

    /// Whether the user has opted to stay signed in across sessions.
    @Published var keepSignedIn: Bool = false

    /// Non-nil when an error banner should be displayed to the user.
    @Published var errorMessage: String? = nil

    // MARK: - Computed state

    /// `true` only when both `username` and `password` contain at least one character.
    var isSignInEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }

    // MARK: - Actions

    /// Invoked when the user taps Sign In.
    ///
    /// - Parameters:
    ///   - username: The entered username/email.
    ///   - password: The entered password.
    ///   - keepSignedIn: Whether the user chose to stay signed in.
    private let onSignIn: (String, String, Bool) -> Void

    // MARK: - Init

    /// Creates a `LoginViewModel`.
    ///
    /// - Parameter onSignIn: Closure called when the user submits the form.
    ///   Defaults to a no-op so the ViewModel can be instantiated without a
    ///   concrete handler (e.g. in unit tests or Xcode Previews).
    init(onSignIn: @escaping (String, String, Bool) -> Void = { _, _, _ in }) {
        self.onSignIn = onSignIn
    }

    // MARK: - Public interface

    /// Triggers the sign-in action with the current form values.
    func signIn() {
        onSignIn(username, password, keepSignedIn)
    }
}
