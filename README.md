# AcmeBank iOS

An iOS 17+ banking app built with Swift 5.10 and SwiftUI.

## Quick Start

```bash
git clone <repo-url>
cd AcmeBank
./setup.sh
```

`setup.sh` installs [XcodeGen](https://github.com/yonaskolb/XcodeGen) via Homebrew if
missing, generates `AcmeBank.xcodeproj` from `project.yml`, and opens the project in
Xcode.

**Manual fallback** (for environments that block shell scripts):
```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

> **Note:** `AcmeBank.xcodeproj` is git-ignored. It is generated from `project.yml`
> and must not be committed. Always run `xcodegen generate` after pulling changes that
> modify `project.yml`.

## Running Tests

In Xcode press `⌘U`, or from the command line:

```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Project Structure

See [CLAUDE.md](CLAUDE.md) for the full architecture overview, planned features, and
the branch/PR conventions all contributors must follow.

## Status

This repository is at **Day-1 bootstrap** — the app launches and displays a placeholder
screen. Feature implementation starts in follow-up PRs (auth, networking, screens, etc.).
