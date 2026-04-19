// LGSpacing.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Spacing Tokens

/// Spacing constants used throughout the LiquidGlass framework.
///
/// These are framework-level constants — not configurable per theme — to enforce
/// visual coherence and concentric proportions across all components.
///
/// Always use these values instead of raw numbers for padding, spacing, and gaps.
public enum LGSpacing {
    /// 4 pt — tight internal padding, separator insets.
    public static let xs: CGFloat = 4
    /// 8 pt — icon-to-label gaps, small stack spacing.
    public static let sm: CGFloat = 8
    /// 16 pt — standard component padding and list item spacing.
    public static let md: CGFloat = 16
    /// 24 pt — card padding, section spacing.
    public static let lg: CGFloat = 24
    /// 32 pt — hero section margins, large inter-section gaps.
    public static let xl: CGFloat = 32
    /// 48 pt — full-screen vertical rhythm, display section separation.
    public static let xxl: CGFloat = 48
}
