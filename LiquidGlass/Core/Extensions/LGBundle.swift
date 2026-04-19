// LGBundle.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Bundle Reference

extension Bundle {
    /// The bundle that contains the LiquidGlass framework resources (localized strings, assets, etc.).
    ///
    /// Use this instead of `Bundle.module` (which is SPM-only) when constructing localised `Text`
    /// values from within the framework itself.
    ///
    /// ```swift
    /// Text("lg.button.close", bundle: .lg)
    /// ```
    static var lg: Bundle { Bundle(for: _LGBundleToken.self) }
}

/// Private class used solely to locate the LiquidGlass framework bundle at runtime.
/// Must be a class (reference type) for `Bundle(for:)` to work correctly.
private final class _LGBundleToken: NSObject {}

// MARK: - Accessibility Preview Environment Entries

extension EnvironmentValues {
    /// LiquidGlass-owned override for `accessibilityReduceTransparency`.
    ///
    /// In iOS 26, the system key `\.accessibilityReduceTransparency` is read-only and cannot be
    /// set from `#Preview` blocks. Views internally combine both values:
    /// `systemReduceTransparency || lgReduceTransparency`.
    ///
    /// Use `.lgPreviewReduceTransparency()` in previews instead of
    /// `.lgPreviewReduceTransparency()`.
    @Entry var lgReduceTransparency: Bool = false

    /// LiquidGlass-owned override for `accessibilityReduceMotion`.
    ///
    /// Use `.lgPreviewReduceMotion()` in previews.
    @Entry var lgReduceMotion: Bool = false
}

// MARK: - Preview Helper Modifiers

extension View {
    /// Injects the LiquidGlass reduce-transparency override into this view's environment.
    ///
    /// Use in `#Preview` blocks to test opaque-surface fallback paths:
    /// ```swift
    /// #Preview("My View — Reduce Transparency") {
    ///     MyView().lgPreviewReduceTransparency()
    /// }
    /// ```
    public func lgPreviewReduceTransparency(_ value: Bool = true) -> some View {
        environment(\.lgReduceTransparency, value)
    }

    /// Injects the LiquidGlass reduce-motion override into this view's environment.
    ///
    /// Use in `#Preview` blocks to test instant-state-change fallback paths.
    public func lgPreviewReduceMotion(_ value: Bool = true) -> some View {
        environment(\.lgReduceMotion, value)
    }
}
