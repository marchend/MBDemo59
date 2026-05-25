# Bootstrap Plan — AcmeBank iOS

## In scope (this PR)

### Project name + tech stack decisions
- **App name:** AcmeBank
- **Platform:** iOS 17+
- **Language:** Swift 5.10
- **UI Framework:** SwiftUI (`@main` App entry point + `ContentView`)
- **Architecture:** MVVM + Coordinator (shell only — entry point only)
- **Project generation:** XcodeGen (`project.yml`)
- **Test framework:** XCTest (unit tests)
- **Min Xcode:** 16.0
- **Bundle ID:** `com.acmebank.mobile`

### Directory structure (bootstrap only)
```
AcmeBank/
├── App/
│   ├── AcmeBankApp.swift          # @main SwiftUI App entry
│   └── ContentView.swift          # "AcmeBank" placeholder text
├── Resources/
│   └── Assets.xcassets/
│       ├── Contents.json
│       └── AppIcon.appiconset/
│           └── Contents.json
├── PrivacyInfo.xcprivacy
└── AcmeBank.entitlements
AcmeBankTests/
└── AcmeBankTests.swift            # ONE trivial test: ContentView() initializes
project.yml
.gitignore
setup.sh
CLAUDE.md
AGENT.md
README.md
bootstrap_plan.md
```

### Files created in this PR
| File | Purpose |
|------|---------|
| `project.yml` | XcodeGen spec — generates AcmeBank.xcodeproj |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI App entry with WindowGroup |
| `AcmeBank/App/ContentView.swift` | Placeholder view showing "AcmeBank" text |
| `AcmeBank/Resources/Assets.xcassets/Contents.json` | Asset catalog metadata |
| `AcmeBank/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json` | AppIcon stub (prevents actool error) |
| `AcmeBank/PrivacyInfo.xcprivacy` | Privacy manifest (required by App Store) |
| `AcmeBank/AcmeBank.entitlements` | Keychain access groups (CI-safe) |
| `AcmeBankTests/AcmeBankTests.swift` | ONE test: `test_contentView_initializes` |
| `.gitignore` | Ignores generated .xcodeproj, DerivedData, etc. |
| `setup.sh` | One-shot: installs XcodeGen, runs generate, opens Xcode |
| `CLAUDE.md` | Project docs for Anthropic agents |
| `AGENT.md` | Project docs for all other agents (same content) |
| `README.md` | Human-facing getting-started docs |

### How to run locally
```bash
git clone <repo>
cd AcmeBank
./setup.sh          # installs XcodeGen if needed, generates .xcodeproj, opens Xcode
```
Or manually:
```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

### How to run tests
In Xcode: `⌘U` on the `AcmeBank` scheme.
CLI (after `xcodegen generate`):
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

### Definition of Hello World
App launches, shows a single SwiftUI screen with the text **"AcmeBank"** centred on a white background.  
The unit test target compiles and links against the app module; `test_contentView_initializes` instantiates `ContentView()` and passes.

---

## Out of scope — deferred to future work

- **Okta OIDC authentication** (`AuthService`, `KeychainStore`, `UserSession`, `Okta.plist`) — future PR
- **MVVM + Coordinator architecture** (`AppCoordinator`, `RootView`, `LoginCoordinator`, `TabBarCoordinator`, feature coordinators) — future PR
- **Networking layer** (`APIClient`, `APIRouter`, `APIError`, `RequestInterceptor`) — future PR
- **Domain models** (`Account`, `Transaction`, `Customer`, `TransferRequest`) — future PR
- **Repository protocols** (`AccountRepositoryProtocol`, `TransactionRepositoryProtocol`, etc.) — future PR
- **Mock data layer** (`MockAccountRepository`, `MockTransactionRepository`, etc.) — future PR
- **Login feature** (`LoginView`, `LoginViewModel`) — future PR
- **Home feature** (`HomeView`, `HomeViewModel`, sub-views) — future PR
- **Accounts, Transfer, Cards features** — future PR
- **Design system tokens** (`Colors.swift`, `Typography.swift`, `Assets.xcassets` branding) — future PR
- **Internal notifications** (`AppNotification`, `NotificationPublisher`, `NotificationKey`) — future PR
- **SwiftLint** configuration (`.swiftlint.yml`) — future PR
- **CI workflow** (`ios-build.yml` with `xcodebuild test` + `swiftlint`) — future PR
- **XCUITest target** (`AcmeBankUITests/`) with Login/Transfer UI flows — future PR
- **`Decimal+Currency`, `Date+Greeting`, `String+Initials` extensions** — future PR
- **`Localizable.strings` / localization** — future PR
- **xcconfig for `API_BASE_URL` and CI secret injection** — future PR
