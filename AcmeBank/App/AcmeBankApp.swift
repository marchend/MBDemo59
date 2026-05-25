import SwiftUI

@main
struct AcmeBankApp: App {
    var body: some Scene {
        WindowGroup {
            // LoginView is the root screen on first launch.
            // The onSignIn closure is currently a no-op stub; the real
            // authentication flow (Okta DirectAuth) is wired in a
            // subsequent PR that introduces the auth layer.
            LoginView()
        }
    }
}
