# Getting Started with LiquidGlass

Learn how to integrate the framework and render your first screen.

## Install the XCFramework

1. Build the binary from the repo root:
   ```bash
   chmod +x Scripts/build-xcframework.sh
   ./Scripts/build-xcframework.sh
   ```
2. In Xcode, select your target → **Frameworks, Libraries, and Embedded Content** → drag `build/LiquidGlass.xcframework`.
3. Set the embed option to **Embed & Sign**.

## Apply a theme (optional)

LiquidGlass ships with `LGDefaultTheme`, which maps to SwiftUI's semantic colors. You can use the framework without any theme configuration.

To apply a custom theme, set it at your app root:

```swift
import LiquidGlass

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .lgTheme(MyBrandTheme())
        }
    }
}
```

See <doc:Theming> for details on creating a custom theme.

## Render a template screen

Each template is a SwiftUI view that accepts a content object conforming to its protocol.

### Banking dashboard example

```swift
import LiquidGlass

struct MyDashboardContent: LGBankingDashboardContent {
    var accountName: LocalizedStringKey { "Savings Account" }
    var balanceAmount: Decimal { 8_432.50 }
    var currencyCode: String { "USD" }
    var transactions: [LGTransactionItem] {
        [
            LGTransactionItem(id: UUID(), merchant: "Apple Store", amount: -299.00, date: .now, category: .shopping),
            LGTransactionItem(id: UUID(), merchant: "Salary", amount: 5_000.00, date: .now, category: .income)
        ]
    }
    @ViewBuilder var heroCard: some View {
        // Your own custom card, or leave it using the default by omitting this slot
        EmptyView()
    }
}

struct ContentView: View {
    var body: some View {
        LGBankingDashboardView(content: MyDashboardContent())
    }
}
```

## Use individual atoms and molecules

You can use any component independently, without a template:

```swift
import LiquidGlass

struct MyView: View {
    @Environment(\.lgTheme) private var theme

    var body: some View {
        GlassEffectContainer(spacing: 20) {
            VStack(spacing: 20) {
                LGCard(style: .stat(value: "€ 12,345", label: "Balance", trend: .up(3.2)))
                LGButton("Send Money", style: .glass) { /* action */ }
            }
        }
    }
}
```

## Next steps
- <doc:Theming>
- <doc:BuildingTemplates>
- <doc:CreatingComponents>
