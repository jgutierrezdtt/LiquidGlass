<!--
  README.md — LiquidGlass Framework
  Standard: Standard Readme Specification v1.2.0
  https://github.com/RichardLitt/standard-readme/blob/main/spec.md
-->

# LiquidGlass

> Private Swift framework for reusable Liquid Glass UI components, animations, and screen templates targeting Apple platforms.

[![Swift 6](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS 26+](https://img.shields.io/badge/iOS-26%2B-blue.svg)](https://developer.apple.com/ios/)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)](./LICENSE)
[![Build: Xcode 26](https://img.shields.io/badge/Xcode-26%2B-blue.svg)](https://developer.apple.com/xcode/)

LiquidGlass provides a fully composable set of SwiftUI components — from atomic buttons and text fields to full-screen banking, gaming, learning, and e-commerce templates — all built on top of the [Apple Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/materials) visual language introduced in iOS/macOS 26 (Tahoe). The framework is theme-agnostic, locale-aware, and ships zero hardcoded colors or fonts.

---

## Table of Contents

- [Background](#background)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Theme Setup](#theme-setup)
  - [Using Atoms](#using-atoms)
  - [Using Templates](#using-templates)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Localization](#localization)
- [Accessibility](#accessibility)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)

---

## Background

With iOS/macOS 26, Apple introduced the **Liquid Glass** design system — a translucent, physically-based material that adapts to the content behind it. LiquidGlass wraps this API into a production-ready component library following the [Atomic Design](https://atomicdesign.bradfrost.com) methodology:

- **Atoms** — smallest reusable primitives (`LGButton`, `LGTextField`, `LGAvatar`, …)
- **Molecules** — composed groups (`LGCard`, `LGListRow`, `LGSearchBar`, …)
- **Organisms** — layout scaffolds (`LGTabScaffold`, `LGSplitLayout`, `LGHeroDetail`, …)
- **Templates** — full screen implementations per domain (Banking, Gaming, Sports, Shopping, …)

All components read theming tokens from the SwiftUI environment, making the library completely decoupled from any specific brand or color palette.

---

## Requirements

| Requirement | Version |
|---|---|
| Xcode | 26.0+ |
| Swift | 6.0+ |
| iOS / iPadOS | 26.0+ |
| macOS | 26.0+ (Tahoe) |
| tvOS | 26.0+ |
| watchOS | 12.0+ |
| visionOS | 2.0+ |

> **Note:** Liquid Glass APIs are available on all supported OS versions. No `#available` guards are needed when consuming this framework.

---

## Installation

### XCFramework (Recommended)

```bash
# 1. Make the build script executable
chmod +x Scripts/build-xcframework.sh

# 2. Build all platform slices and create the XCFramework
./Scripts/build-xcframework.sh
```

The script produces `build/LiquidGlass.xcframework` containing slices for:
`iphoneos` · `iphonesimulator` · `appletvos` · `appletvsimulator` · `macosx` · `watchos` · `watchsimulator` · `xros` · `xrsimulator`

```
# 3. Drag build/LiquidGlass.xcframework into your target's
#    Frameworks, Libraries, and Embedded Content.
# 4. Set embed mode to "Embed & Sign".
```

### Direct Source Integration

Clone or add this repository as a Git submodule and drag the `LiquidGlass/` folder into your Xcode project, selecting your app target.

---

## Usage

### Theme Setup

Apply a theme at the root of your view hierarchy. If omitted, `LGDefaultTheme` is used automatically.

```swift
import LiquidGlass
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .lgTheme(MyBrandTheme())
        }
    }
}

struct MyBrandTheme: LGThemeProtocol {
    var colors: LGColorTokens {
        LGColorTokens(
            primary:     .accentColor,
            secondary:   Color("SecondaryLabel"),
            surface:     Color("SurfaceBackground"),
            accent:      .purple,
            destructive: .red,
            onPrimary:   .white,
            onSurface:   Color("PrimaryLabel")
        )
    }
    var typography: LGTypographyTokens {
        LGTypographyTokens(
            display:  .largeTitle.bold(),
            headline: .headline,
            title:    .title2.weight(.semibold),
            body:     .body,
            caption:  .caption,
            label:    .footnote
        )
    }
}
```

### Using Atoms

```swift
import LiquidGlass

// Glass button
LGButton("Confirm", style: .glassProminent) {
    handleConfirm()
}

// Icon button with accessibility
LGIconButton("arrow.up", label: "Send money", hint: "Double-tap to send") {
    handleSend()
}

// Tinted tag
LGTag("Live", systemImage: "circle.fill", style: .accent)

// Avatar with initials fallback
LGAvatar(image: profileImage, initials: "JG", size: .large)
```

### Using Templates

Every template is driven by a **content protocol** — implement it to supply your data and custom views:

```swift
import LiquidGlass

struct MyDashboard: LGBankingDashboardContent {
    var accountName: LocalizedStringKey { "Checking · 4521" }
    var balanceAmount: Decimal          { 24_580.00 }
    var currencyCode:  String           { "USD" }
    var transactions:  [LGTransactionItem] { myTransactions }

    @ViewBuilder var heroCard: some View {
        MyCustomBalanceCard()
    }
    @ViewBuilder var quickActionsView: some View {
        MyQuickActions()
    }
}

// In a SwiftUI view:
LGBankingDashboardView(content: MyDashboard())
```

Available template domains: **Auth**, **Banking**, **Betting**, **Code**, **Gaming**, **Insurance**, **Learning**, **Library**, **News**, **Settings**, **Shopping**, **Sports**.

---

## Project Structure

```
LiquidGlass/
├── Core/
│   ├── Theme/          → LGThemeProtocol, LGDefaultTheme, LGColorTokens,
│   │                     LGTypographyTokens, LGSpacing, LGShape
│   ├── Extensions/     → View+Glass, Animation+LG, LGBundle
│   └── Localization/   → LiquidGlass.xcstrings (7 languages)
├── Components/
│   ├── Atoms/          → LGButton, LGIconButton, LGAvatar, LGBadge,
│   │                     LGTag, LGTextField, LGProgressIndicators, LGStatLabel
│   ├── Molecules/      → LGCard, LGListRow, LGSearchBar, LGToast,
│   │                     LGBanner, LGToolbarGroup, Domain rows
│   └── Organisms/      → LGTabScaffold, LGBottomSheet, LGModal,
│                         LGSplitLayout, LGHeroDetail
├── Templates/
│   ├── Auth/           → LGOnboardingView, LGSignupView
│   ├── Banking/        → LGBankingDashboardView, LGTransactionListView,
│   │                     LGAccountDetailView, LGTransferView
│   ├── Betting/        → LGEventsListView, LGBetSlipView, LGBetAccountView
│   ├── Code/           → LGRepoListView, LGFileBrowserView, LGIssueListView
│   ├── Gaming/         → LGGameHomeView, LGLeaderboardView, LGAchievementsView
│   ├── Insurance/      → LGPolicyOverviewView, LGClaimFormView, LGCoverageView
│   ├── Learning/       → LGCourseHomeView, LGLessonView,
│   │                     LGProgressDashboardView, LGQuizView
│   ├── Library/        → LGBookCatalogView, LGBookDetailView, LGReaderView
│   ├── News/           → LGNewsFeedView, LGArticleReaderView
│   ├── Settings/       → LGSettingsView, LGProfileView
│   ├── Shopping/       → LGProductCatalogView, LGProductDetailView,
│   │                     LGCartView, LGCheckoutView
│   └── Sports/         → LGLeagueStandingsView, LGMatchDetailView,
│                         LGTeamProfileView, LGLiveScoreView
├── Animations/         → LGAnimations, LGTransitions
├── Scripts/            → build-xcframework.sh
├── docs/
│   ├── adr/            → ADR-001 … ADR-008
│   └── diagrams/       → C4 & component diagrams (Mermaid)
└── LiquidGlass.docc/   → DocC documentation catalog
```

---

## Architecture

LiquidGlass follows [Atomic Design](https://atomicdesign.bradfrost.com) with strict layer isolation:

```
Core  ←  Atoms  ←  Molecules  ←  Organisms  ←  Templates
          ↑           ↑              ↑
       (Core)     (Atoms+Core)  (Molecules+Atoms)
Animations  ←  Core only
```

Import direction is **always downward**. An Atom may never import a Molecule. A Template may never import another Template.

All architectural decisions are recorded in `docs/adr/`. Diagrams (Context, Container, Component, and Dynamic views) are in `docs/diagrams/` as Mermaid source.

---

## Localization

All user-facing strings are stored in `LiquidGlass/Core/Localization/LiquidGlass.xcstrings` and shipped inside the framework bundle. Supported languages out of the box:

| Code | Language |
|------|----------|
| `en` | English |
| `es` | Spanish |
| `fr` | French |
| `de` | German |
| `ar` | Arabic (RTL) |
| `ja` | Japanese |
| `zh-Hans` | Simplified Chinese |

All components accept `LocalizedStringKey` parameters and natively support RTL layouts.

---

## Accessibility

Every component in LiquidGlass is built to meet **WCAG 2.2 Level AA** and Apple's [Accessibility Programming Guide for iOS](https://developer.apple.com/accessibility/ios/):

- All `Image(systemName:)` icons carry `.accessibilityLabel` or `.accessibilityHidden(true)`
- All interactive elements carry `.accessibilityHint`
- `@Environment(\.accessibilityReduceTransparency)` — glass surfaces fall back to opaque materials
- `@Environment(\.accessibilityReduceMotion)` — spring animations are replaced with instant state changes
- Dynamic Type is supported throughout; no raw point sizes are hardcoded

---

## Documentation

Build the DocC catalog directly in Xcode:

```
Product → Build Documentation  (⌃⇧⌘D)
```

Or from the command line:

```bash
xcodebuild docbuild \
  -scheme LiquidGlass \
  -destination 'generic/platform=iOS Simulator'
```

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for code style, branch strategy, and pull-request requirements.

---

## Security

See [SECURITY.md](./SECURITY.md) for the vulnerability disclosure policy and supported version matrix.

---

## License

See [LICENSE](./LICENSE). This software is proprietary and all rights are reserved. Unauthorized copying, distribution, or modification is strictly prohibited.
