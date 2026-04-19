# Creating New Components

A step-by-step guide to adding a new atom, molecule, or organism to LiquidGlass.

## Decide the layer

Before writing code, decide which layer the component belongs to:

| Layer | When to use |
|---|---|
| **Atom** | Single-responsibility control with no composed sub-components |
| **Molecule** | Combines 2+ atoms with presentation logic |
| **Organism** | Full reusable layout section (toolbar, scaffold, sheet) |
| **Template** | A complete screen for a specific domain |

## File structure

Create one file per public type, named after the type:
```
LiquidGlass/Components/Atoms/LGMyAtom.swift
```

### Standard file template

```swift
// LGMyAtom.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Public API

/// Brief one-line description of what this atom does.
///
/// Use `LGMyAtom` when you need to... (one sentence).
///
/// - Note: Wraps multiple instances in a `GlassEffectContainer` for best performance.
public struct LGMyAtom: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let label: LocalizedStringKey
    private let action: () -> Void

    /// Creates an `LGMyAtom`.
    /// - Parameters:
    ///   - label: The accessible label displayed to the user.
    ///   - action: The closure executed when the user activates this atom.
    public init(_ label: LocalizedStringKey, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onPrimary)
                .padding(.horizontal, LGSpacing.md)
                .padding(.vertical, LGSpacing.sm)
        }
        .glassEffect(.regular.tint(theme.colors.primary).interactive())
        .accessibilityLabel(Text(label))
        .accessibilityHint(Text("lg.myatom.hint", bundle: .module))
    }
}

// MARK: - Preview

private struct LGMyAtomPreviewContent: View {
    var body: some View {
        GlassEffectContainer(spacing: 16) {
            VStack(spacing: 16) {
                LGMyAtom("Action") { }
            }
        }
        .padding()
    }
}

#Preview("Default") {
    LGMyAtomPreviewContent()
}

#Preview("Reduce Transparency") {
    LGMyAtomPreviewContent()
        .environment(\.accessibilityReduceTransparency, true)
}
```

## Registering the string key

Add any new localizable strings to the String Catalog:
`LiquidGlass/Core/Localization/LiquidGlass.xcstrings`

Key pattern: `lg.<componentname>.<purpose>`
Example: `lg.myatom.hint` → `"Double-tap to activate"`

## Accessibility requirements

Every component **must**:
- Have `.accessibilityLabel` on every `Image(systemName:)`.
- Have `.accessibilityHint` on every interactive element.
- Provide an opaque fallback when `reduceTransparency == true`.
- Skip or instant-switch animations when `reduceMotion == true`.

## Liquid Glass rules to check

- Apply `.glassEffect()` **after** all visual modifiers (padding, font, foregroundStyle).
- If the component will typically appear alongside other glass components, document this in a note so consumers know to wrap them in `GlassEffectContainer`.
- Never nest `GlassEffectContainer`.

## Preview requirements

Provide at least two `#Preview` blocks:
1. **Default** — standard appearance.
2. **Reduce Transparency** — `.environment(\.accessibilityReduceTransparency, true)`.

Optional additional previews: dark mode, large Dynamic Type, RTL.

## Run the checklist

Before considering the component complete, go through the full checklist in `CONTRIBUTING.md`.
