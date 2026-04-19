# Theming

Create and apply a custom theme to make LiquidGlass match your brand.

## Overview

All LiquidGlass components read their visual style from `@Environment(\.lgTheme)`. This environment value holds any type conforming to `LGThemeProtocol`. The framework ships with `LGDefaultTheme`, which maps tokens to SwiftUI semantic colors so everything works without any configuration.

## LGThemeProtocol

```swift
public protocol LGThemeProtocol {
    var colors: LGColorTokens { get }
    var typography: LGTypographyTokens { get }
}
```

## Color tokens

`LGColorTokens` has these semantic slots:

| Token | Intended use |
|---|---|
| `primary` | Brand primary actions, filled buttons, highlights |
| `secondary` | Secondary actions, muted labels |
| `surface` | Card and panel backgrounds (glass tint) |
| `accent` | Special highlights, badges, trending indicators |
| `destructive` | Delete, error, warning states |
| `onPrimary` | Text/icons on top of `primary`-colored surfaces |
| `onSurface` | Body text and icons on top of `surface`-colored areas |

## Typography tokens

`LGTypographyTokens` uses SwiftUI's `Font` type so Dynamic Type works automatically:

| Token | Recommended system equivalent |
|---|---|
| `display` | `.largeTitle` |
| `headline` | `.headline` |
| `title` | `.title2` |
| `body` | `.body` |
| `caption` | `.caption` |
| `label` | `.footnote` |

To use a custom font with Dynamic Type scaling:
```swift
LGTypographyTokens(
    display: .custom("YourFont-Bold", relativeTo: .largeTitle),
    headline: .custom("YourFont-SemiBold", relativeTo: .headline),
    body: .custom("YourFont-Regular", relativeTo: .body),
    caption: .custom("YourFont-Regular", relativeTo: .caption),
    title: .custom("YourFont-Medium", relativeTo: .title2),
    label: .custom("YourFont-Regular", relativeTo: .footnote)
)
```

## Creating a custom theme

```swift
import LiquidGlass

struct MyBankingTheme: LGThemeProtocol {
    var colors: LGColorTokens {
        LGColorTokens(
            primary: Color("BrandNavy"),
            secondary: Color("BrandSlate"),
            surface: Color("CardBackground"),
            accent: Color("BrandGold"),
            destructive: Color("AlertRed"),
            onPrimary: .white,
            onSurface: Color("TextPrimary")
        )
    }

    var typography: LGTypographyTokens {
        LGTypographyTokens(
            display: .custom("Montserrat-Bold", relativeTo: .largeTitle),
            headline: .custom("Montserrat-SemiBold", relativeTo: .headline),
            title: .custom("Montserrat-Medium", relativeTo: .title2),
            body: .custom("Montserrat-Regular", relativeTo: .body),
            caption: .custom("Montserrat-Regular", relativeTo: .caption),
            label: .custom("Montserrat-Regular", relativeTo: .footnote)
        )
    }
}
```

## Applying the theme

Apply it once at the root of your app:

```swift
@main
struct BankingApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .lgTheme(MyBankingTheme())
        }
    }
}
```

## Dark mode and color variants

Define your colors with `Color(light:dark:)` or use `Color("TokenName")` from your Asset Catalog with separate light/dark variants. LiquidGlass does not manage dark mode — it delegates to SwiftUI's color system.

## Spacing and shapes

Spacing and shape tokens are **framework constants**, not part of the theme, to ensure visual coherence:

```swift
// Spacing — use these, never raw numbers
LGSpacing.xs   // 4
LGSpacing.sm   // 8
LGSpacing.md   // 16
LGSpacing.lg   // 24
LGSpacing.xl   // 32
LGSpacing.xxl  // 48

// Shapes
LGShape.capsule          // Capsule()
LGShape.rounded(.sm)     // RoundedRectangle(cornerRadius: 8)
LGShape.rounded(.md)     // RoundedRectangle(cornerRadius: 12)
LGShape.rounded(.lg)     // RoundedRectangle(cornerRadius: 20)
```
