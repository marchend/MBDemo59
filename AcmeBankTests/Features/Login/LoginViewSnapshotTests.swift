import XCTest
import SwiftUI
import SnapshotTesting
@testable import AcmeBank

/// Snapshot tests for the Login screen views.
///
/// These tests capture the rendered appearance of `LoginView` and its key
/// sub-views in representative states. On the first run (or whenever the
/// recorded baselines are deleted) the tests write new reference images
/// under `__Snapshots__/LoginViewSnapshotTests/`. Subsequent runs compare
/// against those baselines and fail if the rendered output differs.
///
/// **Baseline recording:** the global `SnapshotTesting.isRecording` flag is
/// set to `true` for this initial PR because no baseline images exist yet.
/// Once the first CI run records the reference images, flip it to `false`
/// (and commit the generated PNGs) so that future PRs catch regressions.
final class LoginViewSnapshotTests: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        // Record mode: always write reference images on this run.
        // Flip to `false` once baselines are committed.
        isRecording = true
    }

    // MARK: - LoginView — full screen

    /// Default state: both fields empty, error banner hidden,
    /// Sign in button grayed out.
    func test_loginView_defaultState() {
        let sut = UIHostingController(rootView: LoginView())
        assertSnapshot(of: sut, as: .image(on: .iPhoneX))
    }

    // MARK: - Sub-view snapshots

    /// `HexagonLogoView` renders as the expected navy hexagon with "A".
    func test_hexagonLogoView_defaultSize() {
        let sut = UIHostingController(
            rootView: HexagonLogoView()
                .padding(16)
                .background(Color(.systemBackground))
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `OktaHeaderView` renders the lock icon, tenant label, and Okta logo.
    func test_oktaHeaderView() {
        let sut = UIHostingController(
            rootView: OktaHeaderView()
                .frame(width: 390)
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `ErrorBannerView` — message visible state.
    func test_errorBannerView_messageVisible() {
        let sut = UIHostingController(
            rootView: ErrorBannerView(
                message: "Incorrect username or password. Please try again."
            )
            .padding(16)
            .frame(width: 390)
            .background(Color(.systemBackground))
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `ErrorBannerView` — nil message renders as empty / zero-height.
    func test_errorBannerView_nilMessage_rendersEmpty() {
        let sut = UIHostingController(
            rootView: ErrorBannerView(message: nil)
                .padding(16)
                .frame(width: 390, height: 80)
                .background(Color(.systemBackground))
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `SecuredByOktaFooterView` renders the "Secured by okta" strip.
    func test_securedByOktaFooterView() {
        let sut = UIHostingController(
            rootView: SecuredByOktaFooterView()
                .frame(width: 390)
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `PasswordFieldView` in the hidden-password state.
    func test_passwordFieldView_hidden() {
        let sut = UIHostingController(
            rootView: PasswordFieldView(
                text: .constant("secret"),
                isVisible: .constant(false)
            )
            .padding(16)
            .frame(width: 390)
            .background(Color(.systemBackground))
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `PasswordFieldView` in the revealed-password state.
    func test_passwordFieldView_visible() {
        let sut = UIHostingController(
            rootView: PasswordFieldView(
                text: .constant("secret"),
                isVisible: .constant(true)
            )
            .padding(16)
            .frame(width: 390)
            .background(Color(.systemBackground))
        )
        assertSnapshot(of: sut, as: .image)
    }

    /// `PlaceholderAccountCreationView` renders the "Coming soon" stub.
    func test_placeholderAccountCreationView() {
        let sut = UIHostingController(
            rootView: PlaceholderAccountCreationView()
                .frame(width: 390, height: 400)
        )
        assertSnapshot(of: sut, as: .image)
    }
}
