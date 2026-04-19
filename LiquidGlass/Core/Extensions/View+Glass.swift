// View+Glass.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Glass Convenience Modifiers

public extension View {

    /// Applies the default Liquid Glass capsule effect.
    ///
    /// Shorthand for `.glassEffect()`.
    func lgGlass() -> some View {
        glassEffect()
    }

    /// Applies a tinted Liquid Glass capsule effect.
    ///
    /// Use for interactive controls that carry brand color prominence.
    /// - Parameter tint: The color to tint the glass material.
    func lgGlass(tint: Color) -> some View {
        glassEffect(.regular.tint(tint))
    }

    /// Applies an interactive Liquid Glass capsule effect.
    ///
    /// Equivalent to `.glassEffect(.regular.interactive())`. Use this for
    /// tappable controls that are not `Button`-based.
    func lgGlassInteractive() -> some View {
        glassEffect(.regular.interactive())
    }

    /// Applies a tinted, interactive Liquid Glass capsule effect.
    ///
    /// - Parameter tint: The color to tint the glass material.
    func lgGlassInteractive(tint: Color) -> some View {
        glassEffect(.regular.tint(tint).interactive())
    }

    /// Applies a Liquid Glass card effect using a rounded rectangle shape.
    ///
    /// - Parameter size: The corner radius tier for the rounded rectangle. Defaults to `.md`.
    func lgGlassCard(_ size: LGShapeSize = .md) -> some View {
        glassEffect(in: .rect(cornerRadius: size.radius))
    }

    /// Applies an opaque surface background using the theme's surface color.
    ///
    /// Use as a fallback when `accessibilityReduceTransparency` is enabled.
    /// - Parameters:
    ///   - color: The fill color for the opaque background.
    ///   - size: The corner radius tier. Defaults to `.md`.
    func lgOpaqueSurface(_ color: Color, size: LGShapeSize = .md) -> some View {
        background(
            LGShape.rounded(size)
                .fill(color.opacity(0.95))
        )
    }
}
