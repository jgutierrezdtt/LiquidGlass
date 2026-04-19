// LGTypography.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Typography Tokens

/// Semantic typography tokens. All values are SwiftUI `Font` instances, which
/// automatically respect Dynamic Type unless overridden with a fixed size.
///
/// Use `Font.custom(_:relativeTo:)` to register custom fonts that still scale with
/// the user's accessibility text size setting.
public struct LGTypographyTokens {
    /// Large display numbers and hero text (maps to `.largeTitle` by default).
    public let display: Font
    /// Section and card headlines (maps to `.headline` by default).
    public let headline: Font
    /// Navigation titles and secondary large text (maps to `.title2` by default).
    public let title: Font
    /// Standard body copy (maps to `.body` by default).
    public let body: Font
    /// Metadata, timestamps, supporting details (maps to `.caption` by default).
    public let caption: Font
    /// Dense labels, badges, table cells (maps to `.footnote` by default).
    public let label: Font

    /// Creates a full set of semantic typography tokens.
    public init(
        display: Font,
        headline: Font,
        title: Font,
        body: Font,
        caption: Font,
        label: Font
    ) {
        self.display = display
        self.headline = headline
        self.title = title
        self.body = body
        self.caption = caption
        self.label = label
    }
}
