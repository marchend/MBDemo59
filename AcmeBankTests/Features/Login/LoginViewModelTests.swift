import XCTest
@testable import AcmeBank

final class LoginViewModelTests: XCTestCase {

    // MARK: - Initial state

    func test_initialState_usernameIsEmpty() {
        let sut = LoginViewModel()
        XCTAssertEqual(sut.username, "")
    }

    func test_initialState_passwordIsEmpty() {
        let sut = LoginViewModel()
        XCTAssertEqual(sut.password, "")
    }

    func test_initialState_isSignInEnabledIsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_initialState_isPasswordVisibleIsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isPasswordVisible)
    }

    func test_initialState_keepSignedInIsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.keepSignedIn)
    }

    func test_initialState_errorMessageIsNil() {
        let sut = LoginViewModel()
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - isSignInEnabled toggling

    func test_isSignInEnabled_trueWhenBothUsernameAndPasswordNonEmpty() {
        let sut = LoginViewModel()
        sut.username = "user@example.com"
        sut.password = "secret"
        XCTAssertTrue(sut.isSignInEnabled)
    }

    func test_isSignInEnabled_falseWhenOnlyUsernameIsSet() {
        let sut = LoginViewModel()
        sut.username = "user@example.com"
        sut.password = ""
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_isSignInEnabled_falseWhenOnlyPasswordIsSet() {
        let sut = LoginViewModel()
        sut.username = ""
        sut.password = "secret"
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_isSignInEnabled_falseAfterClearingUsername() {
        let sut = LoginViewModel()
        sut.username = "user@example.com"
        sut.password = "secret"
        XCTAssertTrue(sut.isSignInEnabled)

        sut.username = ""
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_isSignInEnabled_falseAfterClearingPassword() {
        let sut = LoginViewModel()
        sut.username = "user@example.com"
        sut.password = "secret"
        XCTAssertTrue(sut.isSignInEnabled)

        sut.password = ""
        XCTAssertFalse(sut.isSignInEnabled)
    }

    // MARK: - isPasswordVisible toggling

    func test_isPasswordVisible_reflectsAssignedValue() {
        let sut = LoginViewModel()
        sut.isPasswordVisible = true
        XCTAssertTrue(sut.isPasswordVisible)

        sut.isPasswordVisible = false
        XCTAssertFalse(sut.isPasswordVisible)
    }

    // MARK: - errorMessage visibility

    func test_errorMessage_nonNilStringMakesBannerLogicallyVisible() {
        let sut = LoginViewModel()
        sut.errorMessage = "Invalid credentials. Please try again."
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_errorMessage_nilHidesBanner() {
        let sut = LoginViewModel()
        sut.errorMessage = "Some error"
        sut.errorMessage = nil
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - onSignIn closure contract

    func test_signIn_invokesClosureWithCurrentFormValues() {
        var capturedUsername: String?
        var capturedPassword: String?
        var capturedKeepSignedIn: Bool?

        let sut = LoginViewModel { username, password, keepSignedIn in
            capturedUsername = username
            capturedPassword = password
            capturedKeepSignedIn = keepSignedIn
        }

        sut.username = "user@example.com"
        sut.password = "p@ssw0rd"
        sut.keepSignedIn = true
        sut.signIn()

        XCTAssertEqual(capturedUsername, "user@example.com")
        XCTAssertEqual(capturedPassword, "p@ssw0rd")
        XCTAssertEqual(capturedKeepSignedIn, true)
    }

    func test_signIn_defaultClosureIsNoOp() {
        // Verifies that the default no-op closure doesn't crash when called.
        let sut = LoginViewModel()
        sut.username = "user@example.com"
        sut.password = "secret"
        // Should not throw or crash.
        sut.signIn()
    }
}
