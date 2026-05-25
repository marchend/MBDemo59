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
/// **Baseline recording:** `withSnapshotTesting(record: .missing)` is used
/// so that the library records a baseline PNG if none exists and passes the
/// test; when a baseline already exists it compares and only fails on
/// visual regression. This allows CI to bootstrap baselines on the first
/// run without failing.
final class LoginViewSnapshotTests: XCTestCase {

    // MARK: - LoginView — full screen

    /// Default state: both fields empty, error banner hidden,
    /// Sign in button grayed out.
    func test_loginView_defaultState() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(rootView: LoginView())
            assertSnapshot(of: sut, as: .image(on: .iPhoneX))
        }
    }

    // MARK: - Sub-view snapshots

    /// `HexagonLogoView` renders as the expected navy hexagon with "A".
    func test_hexagonLogoView_defaultSize() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(
                rootView: HexagonLogoView()
                    .padding(16)
                    .background(Color(.systemBackground))
            )
            assertSnapshot(of: sut, as: .image)
        }
    }

    /// `OktaHeaderView` renders the lock icon, tenant label, and Okta logo.
    func test_oktaHeaderView() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(
                rootView: OktaHeaderView()
                    .frame(width: 390)
            )
            assertSnapshot(of: sut, as: .image)
        }
    }

    /// `ErrorBannerView` — message visible state.
    func test_errorBannerView_messageVisible() {
        withSnapshotTesting(record: .missing) {
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
    }

    /// `ErrorBannerView` — nil message renders as empty / zero-height.
    func test_errorBannerView_nilMessage_rendersEmpty() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(
                rootView: ErrorBannerView(message: nil)
                    .padding(16)
                    .frame(width: 390, height: 80)
                    .background(Color(.systemBackground))
            )
            assertSnapshot(of: sut, as: .image)
        }
    }

    /// `SecuredByOktaFooterView` renders the "Secured by okta" strip.
    func test_securedByOktaFooterView() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(
                rootView: SecuredByOktaFooterView()
                    .frame(width: 390)
            )
            assertSnapshot(of: sut, as: .image)
        }
    }

    /// `PasswordFieldView` in the hidden-password state.
    func test_passwordFieldView_hidden() {
        withSnapshotTesting(record: .missing) {
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
    }

    /// `PasswordFieldView` in the revealed-password state.
    func test_passwordFieldView_visible() {
        withSnapshotTesting(record: .missing) {
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
    }

    /// `PlaceholderAccountCreationView` renders the "Coming soon" stub.
    func test_placeholderAccountCreationView() {
        withSnapshotTesting(record: .missing) {
            let sut = UIHostingController(
                rootView: PlaceholderAccountCreationView()
                    .frame(width: 390, height: 400)
            )
            assertSnapshot(of: sut, as: .image)
        }
    }
}
