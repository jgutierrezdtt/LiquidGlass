// LGColors.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Color Tokens

/// Semantic color tokens that every LiquidGlass component reads from `@Environment(\.lgTheme)`.
///
/// All tokens are semantic — their meaning, not their exact hex value, defines them.
/// Define light and dark variants in your Asset Catalog and reference them with `Color("Name")`.
public struct LGColorTokens {
    /// Brand primary color. Used for filled buttons, selected states, primary highlights.
    public let primary: Color
    /// Secondary / muted color. Used for secondary text, labels, less prominent actions.
    public let secondary: Color
    /// Surface background color. Used as the tint behind glass cards and panels.
    public let surface: Color
    /// Accent / emphasis color. Used for badges, trending indicators, decorative highlights.
    public let accent: Color
    /// Destructive / error color. Used for delete actions, errors, warnings.
    public let destructive: Color
    /// Color for text and icons placed on top of `primary`-colored surfaces.
    public let onPrimary: Color
    /// Color for body text and icons placed on top of `surface`-colored areas.
    public let onSurface: Color

    /// Creates a full set of semantic color tokens.
    public init(
        primary: Color,
        secondary: Color,
        surface: Color,
        accent: Color,
        destructive: Color,
        onPrimary: Color,
        onSurface: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.surface = surface
        self.accent = accent
        self.destructive = destructive
        self.onPrimary = onPrimary
        self.onSurface = onSurface
    }
}
