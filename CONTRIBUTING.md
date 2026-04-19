# Contributing to LiquidGlass

## Checklist for a new component

Before a PR can be merged, every new component or template must pass all items:

### Naming
- [ ] Type name starts with `LG` prefix (e.g., `LGMyComponent`)
- [ ] Template protocol is named `LGMyComponentContent`
- [ ] Template view is named `LGMyComponentView`
- [ ] File is named identically to the primary type it exports

### Architecture
- [ ] Component lives in the correct layer (`Atoms/`, `Molecules/`, `Organisms/`, `Templates/<Domain>/`)
- [ ] No upward imports (Atom must not import a Molecule, etc.)
- [ ] No `AnyView` usage — use generics or `@ViewBuilder`
- [ ] No singletons — inject via `@Environment` or `init` parameters

### Theme
- [ ] No hardcoded colors (no `.blue`, no `Color(#colorLiteral(...))`)
- [ ] No hardcoded font sizes (no `.system(size: 14)`)
- [ ] All colors read from `@Environment(\.lgTheme).colors.X`
- [ ] All fonts read from `@Environment(\.lgTheme).typography.X`
- [ ] Spacing uses `LGSpacing.xs/sm/md/lg/xl/xxl` constants
- [ ] Corner radii use `LGShape.rounded(.sm/.md/.lg)` or `LGShape.capsule`

### Liquid Glass
- [ ] 2 or more glass shapes are wrapped in a single `GlassEffectContainer`
- [ ] `GlassEffectContainer`s are never nested
- [ ] `.glassEffect()` is applied after all other visual modifiers
- [ ] Interactive controls use `.glassEffect(.regular.tint(color).interactive())`
- [ ] Transitions use `GlassEffectTransition.matchedGeometry` or `.materialize` appropriately

### Accessibility
- [ ] Every `Image(systemName:)` has `.accessibilityLabel(Text(LocalizedStringKey))`
- [ ] Every interactive element has `.accessibilityHint(Text(LocalizedStringKey))`
- [ ] `@Environment(\.accessibilityReduceTransparency)` is respected — opaque fallback provided
- [ ] `@Environment(\.accessibilityReduceMotion)` is respected — animations skipped or instant

### Localization
- [ ] No bare `String` literals for user-facing text
- [ ] Text parameters are `LocalizedStringKey`, not `String`
- [ ] New string keys added to `Core/Localization/LiquidGlass.xcstrings`
- [ ] String keys follow the pattern: `lg.<component>.<purpose>` (e.g., `lg.button.close`)
- [ ] No forced `.leftToRight` layout direction (RTL supported)

### Documentation
- [ ] Public types and their properties have DocC doc comments (`/// Description`)
- [ ] Parameters are documented with `/// - Parameter name: description`
- [ ] The file starts with the standard header:
  ```swift
  // LGFileName.swift
  // LiquidGlass Framework
  // © 2026 — Private Library
  ```

### Preview
- [ ] `#Preview` exists in the file
- [ ] Preview uses a mock `LGXPreviewContent` struct (for templates)
- [ ] Preview covers at least: default state + accessibility variant (reduceTransparency: true)

### Tests
- [ ] At least one unit test for any computed/business logic in the component
- [ ] Test file lives in `LiquidGlassTests/` mirroring the source structure

---

## Adding a new Template domain

1. Create the folder `LiquidGlass/Templates/<DomainName>/`.
2. For each screen, create `LG<ScreenName>.swift` with:
   - `public protocol LG<ScreenName>Content { … }`
   - `public struct LG<ScreenName>View<Content: LG<ScreenName>Content>: View { … }`
   - A private `struct LG<ScreenName>PreviewContent: LG<ScreenName>Content { … }`
   - `#Preview { LG<ScreenName>View(content: LG<ScreenName>PreviewContent()) }`
3. Re-export from `LiquidGlass/LiquidGlass.swift` if needed (the file system sync group handles it automatically).

## Updating architecture decisions

If you need to change a decision captured in `docs/adr/`, do not delete the ADR. Instead:
1. Change its status to `Superseded`.
2. Add a link to the new ADR that replaces it.
3. Create the new ADR with `Status: Accepted`.
