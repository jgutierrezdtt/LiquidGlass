# LiquidGlass Framework — Copilot Custom Instructions

## What this project is
A private Swift framework providing reusable Liquid Glass UI components, animations, and screen templates for any type of app (banking, gaming, sports, learning, shopping, etc.) targeting Apple platforms.

## Deployment targets — STRICT
- iOS 26+, iPadOS 26+, macOS 26+ (Tahoe), tvOS 26+, watchOS 12+
- **Never** add `#if available` guards for Liquid Glass APIs — they are always available in the project's minimum OS
- **Never** suggest UIKit or AppKit — this framework is SwiftUI-only

## Naming conventions
- All public types **must** be prefixed with `LG` (e.g., `LGButton`, `LGCard`, `LGTheme`)
- Protocols that define content slots for templates: `LGXContent` (e.g., `LGBankingDashboardContent`)
- View implementations: `LGXView` (e.g., `LGBankingDashboardView`)
- Every public file exports at minimum: a protocol, a view, and a `#Preview`

## Architecture — Atomic Design
```
Core/           → Theme, Extensions, Localization (foundation, no dependencies)
Components/
  Atoms/        → LGButton, LGAvatar, LGTextField, etc.  (depend on Core only)
  Molecules/    → LGCard, LGListRow, domain rows, etc.   (depend on Atoms + Core)
  Organisms/    → LGTabScaffold, LGSplitLayout, etc.     (depend on Molecules + Atoms)
Templates/      → Screens by domain                      (depend on Organisms + all components)
Animations/     → LGAnimations, LGTransitions            (depend on Core only)
```
**Never** import upward. Atoms cannot import Molecules. Templates cannot import Templates.

## Liquid Glass rules
- **Always** wrap 2 or more glass shapes in a `GlassEffectContainer`
- Use `.glassEffect()` for capsule default, `.glassEffect(in: .rect(cornerRadius:))` for cards/panels
- Use `.glassEffect(.regular.tint(color).interactive())` for tappable controls
- Use `GlassEffectTransition.matchedGeometry` for elements within container spacing, `.materialize` for farther elements
- Use `.glassEffectID(_:in:)` with `@Namespace` to drive morphing transitions
- Use `.glassEffectUnion(id:namespace:)` when multiple views should share a single glass shape

## Theme system — STRICT
- **Never** hardcode colors (e.g., `.blue`, `Color(#colorLiteral(...))`)
- **Never** hardcode font sizes as raw numbers
- Always use `@Environment(\.lgTheme)` to access theme inside views
- Color tokens: `lgTheme.colors.primary`, `.secondary`, `.surface`, `.accent`, `.destructive`
- Typography tokens: `lgTheme.typography.display`, `.headline`, `.body`, `.caption`
- Spacing tokens: `LGSpacing.xs` (4), `.sm` (8), `.md` (16), `.lg` (24), `.xl` (32), `.xxl` (48)
- Shape tokens: `LGShape.capsule`, `.rounded(.sm)`, `.rounded(.md)`, `.rounded(.lg)`

## Localization — STRICT
- **Never** use bare `String` literals for user-facing text — always `LocalizedStringKey` or `String(localized: "key", bundle: .module)`
- All localizable strings live in `LiquidGlass/Core/Localization/LiquidGlass.xcstrings`
- Views accept text as `LocalizedStringKey` parameters, not `String`
- Support RTL layouts natively — never force `.leftToRight` direction

## Animations
- Use `LGAnimations.bounce`, `.snappy`, `.smooth`, `.ease` spring presets — never `.easeIn`, `.easeOut`, `.linear` for glass transitions
- Use `LGAnimations.fast` (0.2s), `.medium` (0.35s), `.slow` (0.5s) for durations
- Wrap all animated state changes in `withAnimation(LGAnimations.snappy) { ... }`

## Accessibility — MANDATORY in every component
- Every `Image(systemName:)` **must** have `.accessibilityLabel(Text(...))`
- Every interactive element **must** have `.accessibilityHint(...)`
- Respect `@Environment(\.accessibilityReduceTransparency)` — provide opaque fallback for glass backgrounds
- Respect `@Environment(\.accessibilityReduceMotion)` — skip spring animations, use instant state changes
- Support Dynamic Type — never `.font(.system(size: 14))`, always `.font(lgTheme.typography.body)`

## tvOS-specific
- Apply `.glassEffect(.regular.interactive())` to focusable controls, conditioned on `@Environment(\.isFocused)`
- Use `@FocusState` for custom focus management

## Performance rules
- Maximum one `GlassEffectContainer` per logical section of the screen
- Never nest `GlassEffectContainer` inside another `GlassEffectContainer`
- Prefer `glassEffectUnion` over many separate `.glassEffect()` calls when shapes should merge at rest

## Template structure — every template must follow this pattern
```swift
// 1. Content protocol (what the consumer provides)
public protocol LGExampleContent {
    associatedtype HeroView: View
    @ViewBuilder var hero: HeroView { get }
    var title: LocalizedStringKey { get }
    // ... other required slots
}

// 2. View implementation
public struct LGExampleView<Content: LGExampleContent>: View {
    @Environment(\.lgTheme) private var theme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let content: Content
    public init(content: Content) { self.content = content }
    public var body: some View { ... }
}

// 3. Preview with mock data
#Preview { LGExampleView(content: LGExamplePreviewContent()) }
```

## File header — always include this in new files
```swift
// LGFileName.swift
// LiquidGlass Framework
// © 2026 — Private Library
```

## What NOT to do
- Do not add `@MainActor` globally — only where truly needed
- Do not use `AnyView` — use generics or `@ViewBuilder`
- Do not create singletons — use `@Environment` and dependency injection
- Do not `print()` — use `Logger` from `os` if logging is needed
- Do not add `TODO:` or `FIXME:` comments without a ticket/ADR reference
