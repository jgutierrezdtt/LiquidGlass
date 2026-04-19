# Theme Injection Flow

```mermaid
flowchart TD
    A["App Root\n.lgTheme(MyTheme())"] --> B["EnvironmentValues\n\.lgTheme = MyTheme()"]
    B --> C["LGBankingDashboardView\n@Environment(\.lgTheme) → theme"]
    C --> D1["LGCard\ntheme.colors.surface"]
    C --> D2["LGButton\ntheme.colors.primary\ntheme.colors.onPrimary"]
    C --> D3["LGStatLabel\ntheme.typography.display"]
    C --> D4["LGListRow\ntheme.typography.body\ntheme.colors.secondary"]
    D1 --> E1["GlassEffect or\nopaque fallback\n(reduceTransparency)"]
    D2 --> E2["ButtonStyle.glass\nor .glassProminent"]
    D3 --> E3["Font token\n→ Dynamic Type scale"]
    D4 --> E4["Font + Color tokens\n→ no hardcoded values"]
```

## Default Theme fallback
If the consumer does **not** call `.lgTheme(_:)`, `LGThemeKey.defaultValue` is used — `LGDefaultTheme`. It maps all color tokens to SwiftUI semantic colors (`.primary`, `.secondary`, `.background`, etc.) so the framework works out of the box with any color scheme.

```mermaid
flowchart LR
    A["No .lgTheme() called"] --> B["EnvironmentValues reads\nLGThemeKey.defaultValue"]
    B --> C["LGDefaultTheme\ncolors.primary → Color.primary\ncolors.surface → Color(.systemBackground)\netc."]
```

## Consumer custom theme
```swift
struct MyBankingTheme: LGThemeProtocol {
    var colors: LGColorTokens {
        LGColorTokens(
            primary: Color("BrandBlue"),
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
            body: .custom("Montserrat-Regular", relativeTo: .body),
            caption: .custom("Montserrat-Regular", relativeTo: .caption)
        )
    }
}
```
