# AcmeBank — Project Context

## Overview
AcmeBank is an iOS 17+ banking app (Swift 5.10 / SwiftUI) that lets customers view
accounts, review transactions, initiate transfers, and manage cards. Auth is handled via
Okta OIDC. The login screen is implemented and is the first screen shown on launch.

## Tech Stack
| Item | Value |
|---|---|
| Platform | iOS 17+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator (`NavigationStack`) |
| Auth | Okta OIDC (`okta-mobile-swift` 2.x) |
| Networking | `URLSession` + async/await |
| Dependency Injection | Constructor injection (no service locator) |
| Notifications | `NotificationCenter` with typed wrappers |
| Project generation | XcodeGen (`project.yml`) |
| Test framework | XCTest (unit) + XCUITest (critical flows) + SnapshotTesting (views) |
| Snapshot testing | `swift-snapshot-testing` 1.17+ (`pointfreeco/swift-snapshot-testing`) |
| Min Xcode | 16.0 |
| Bundle ID | `com.acmebank.mobile` |

## How to Run Locally
```bash
./setup.sh          # installs XcodeGen if needed, generates .xcodeproj, opens Xcode
```
Manual fallback:
```bash
brew install xcodegen && xcodegen generate && open AcmeBank.xcodeproj
```

## How to Run Tests
Xcode: `⌘U` on the `AcmeBank` scheme.
CLI (after `xcodegen generate`):
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Key Directory Structure
```
AcmeBank/
├── App/               # @main entry (AcmeBankApp), ContentView (kept for compatibility)
├── Core/              # Auth, Networking, Notifications, Extensions
├── Domain/            # Models + Repository protocols (no implementations)
├── Data/              # Remote + Mock repository implementations
├── Features/          # Login (implemented), Home, Accounts, Transfer, Cards
│   └── Login/
│       ├── LoginViewModel.swift      # ObservableObject; form state + signIn()
│       ├── LoginView.swift           # Root login screen — wired into AcmeBankApp
│       └── Subviews/                 # OktaHeaderView, HexagonLogoView, etc.
├── Shared/
│   └── Extensions/    # Color+Hex.swift (Color(hex:) + Color.acmeNavy)
├── DesignSystem/      # Colors, Typography, Assets
└── Resources/         # Assets.xcassets, PrivacyInfo.xcprivacy
AcmeBankTests/         # XCTest unit tests (mirrors source tree)
AcmeBankUITests/       # XCUITest critical-flow tests (login, transfer, sign-out)
project.yml            # XcodeGen spec — source of truth for the .xcodeproj
setup.sh               # One-shot post-clone setup
```

## Current App Launch Path
`AcmeBankApp` → `LoginView` (initial scene content).
The `onSignIn` closure is a no-op stub; real Okta auth wired in a future PR.

## Planned Architecture (from spec)

### MVVM + Coordinator
- **View** — SwiftUI `View` struct; renders `@Published` state; zero business logic.
- **ViewModel** — `final class: ObservableObject`; calls repositories; posts notifications.
- **Coordinator** — `ObservableObject` owning `NavigationStack` path; drives push/present declaratively. (deferred — future PR)
- **Repository protocols** in `Domain/`; concrete impls in `Data/`. (deferred — future PR)

### Auth — Okta OIDC (deferred — future PR)
`AuthService` presents browser-based OIDC, decodes ID-token claims, persists tokens to
Keychain via `KeychainStore`, returns a `UserSession` value type.
**Keychain note:** all `SecItem*` calls MUST include `kSecUseDataProtectionKeychain: true`
so they work in CI's `CODE_SIGNING_ALLOWED=NO` simulator builds.

### Networking (deferred — future PR)
`APIClient` wraps `URLSession` + async/await; `APIRouter` enum for endpoints; `APIError`
typed errors; `RequestInterceptor` injects Bearer token + handles 401 → session expiry.

### Coordinator tree (deferred — future PR)
```
AppCoordinator → LoginCoordinator | TabBarCoordinator
                                      ├── HomeCoordinator
                                      ├── TransferCoordinator
                                      ├── CardsCoordinator
                                      └── MoreCoordinator
```

### Notifications (deferred — future PR)
`AppNotification` enum of typed `Notification.Name` constants; `NotificationPublisher`
static helper. Root coordinator subscribes via Combine; ViewModels only post.

### Design System
`Color.acmeNavy` is live in `AcmeBank/Shared/Extensions/Color+Hex.swift`.
Full `Colors.swift` / `Typography.swift` tokens deferred to a future PR.

## Deferred Work
- Okta OIDC authentication (AuthService, KeychainStore, UserSession, Okta.plist)
- MVVM + Coordinator architecture (AppCoordinator, RootView, feature coordinators)
- Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)
- Domain models (Account, Transaction, Customer, TransferRequest)
- Repository protocols + Mock/Remote implementations
- Home, Accounts, Transfer, Cards features
- Design system tokens (full Colors.swift, Typography.swift)
- Internal notifications (AppNotification, NotificationPublisher)
- SwiftLint configuration (.swiftlint.yml)
- XCUITest flows (LoginUITests, TransferUITests)
- Localization (Localizable.strings)
- xcconfig API_BASE_URL injection

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                                 | Receives PRs from              | Promotes to |
|---------|--------------------------------------|--------------------------------|-------------|
| develop | Default integration branch           | feature branches               | qa          |
| qa      | First quality gate                   | develop (promotion PR)         | uat         |
| uat     | Pre-prod acceptance                  | qa (promotion PR)              | main        |
| main    | Production / release tags            | uat (promotion PR)             | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
