# AcmeBank — Project Context

## Overview
AcmeBank is an iOS 17+ banking app (Swift 5.10 / SwiftUI) that lets customers view
accounts, review transactions, initiate transfers, and manage cards. Auth is handled via
Okta OIDC. This repository is in **Day-1 bootstrap state** — the running shell exists;
all feature work is in subsequent PRs.

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
| Test framework | XCTest (unit) + XCUITest (critical flows) |
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
├── App/               # @main entry, ContentView (bootstrap), RootView, AppCoordinator
├── Core/              # Auth, Networking, Notifications, Extensions
├── Domain/            # Models + Repository protocols (no implementations)
├── Data/              # Remote + Mock repository implementations
├── Features/          # Login, Home, Accounts, Transfer, Cards (MVVM+Coordinator per feature)
├── DesignSystem/      # Colors, Typography, Assets
└── Resources/         # Assets.xcassets, PrivacyInfo.xcprivacy
AcmeBankTests/         # XCTest unit tests (mirrors source tree)
AcmeBankUITests/       # XCUITest critical-flow tests (login, transfer, sign-out)
project.yml            # XcodeGen spec — source of truth for the .xcodeproj
setup.sh               # One-shot post-clone setup
```

## Planned Architecture (from spec)

### MVVM + Coordinator
- **View** — SwiftUI `View` struct; renders `@Published` state; zero business logic.
- **ViewModel** — `final class: ObservableObject`; calls repositories; posts notifications. (deferred — future PR)
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

### Design System (deferred — future PR)
`Colors.swift` (acmeNavy, acmeBackground, …) and `Typography.swift` (acmeTitle, …).

## Deferred Work
- Okta OIDC authentication (AuthService, KeychainStore, UserSession, Okta.plist)
- MVVM + Coordinator architecture (AppCoordinator, RootView, feature coordinators)
- Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)
- Domain models (Account, Transaction, Customer, TransferRequest)
- Repository protocols + Mock/Remote implementations
- Login, Home, Accounts, Transfer, Cards features
- Design system tokens (Colors, Typography)
- Internal notifications (AppNotification, NotificationPublisher)
- SwiftLint configuration (.swiftlint.yml)
- CI workflow (ios-build.yml with xcodebuild + swiftlint)
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
