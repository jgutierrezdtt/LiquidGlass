// LGTag.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTag

/// A small status/category label with a glass capsule background.
///
/// Use to annotate items in lists, cards, and grids with semantic status.
///
/// ```swift
/// LGTag("Live", style: .accent)
/// LGTag("Overdue", style: .destructive)
/// LGTag("Completed", style: .surface)
/// ```
public struct LGTag: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let label: LocalizedStringKey
    private let systemImage: String?
    private let style: LGTagStyle

    // MARK: Init

    /// Creates an ``LGTag`` with a text label.
    /// - Parameters:
    ///   - label: The localized tag label.
    ///   - style: The semantic color style. Defaults to `.surface`.
    public init(_ label: LocalizedStringKey, style: LGTagStyle = .surface) {
        self.label = label
        self.systemImage = nil
        self.style = style
    }

    /// Creates an ``LGTag`` with an icon and text label.
    /// - Parameters:
    ///   - label: The localized tag label.
    ///   - systemImage: SF Symbol name for the leading icon.
    ///   - style: The semantic color style. Defaults to `.surface`.
    public init(_ label: LocalizedStringKey, systemImage: String, style: LGTagStyle = .surface) {
        self.label = label
        self.systemImage = systemImage
        self.style = style
    }

    // MARK: Body

    public var body: some View {
        tagContent
            .font(theme.typography.label.weight(.medium))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, LGSpacing.sm)
            .padding(.vertical, LGSpacing.xs)
            .background(tagBackground)
            .accessibilityLabel(Text(label))
    }

    // MARK: Private

    @ViewBuilder
    private var tagContent: some View {
        if let icon = systemImage {
            Label {
                Text(label)
            } icon: {
                Image(systemName: icon)
                    .accessibilityHidden(true)
            }
        } else {
            Text(label)
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .accent: return theme.colors.onPrimary
        case .destructive: return theme.colors.onPrimary
        case .surface: return theme.colors.onSurface
        case .custom(_, let fg): return fg
        }
    }

    private var tintColor: Color {
        switch style {
        case .accent: return theme.colors.accent
        case .destructive: return theme.colors.destructive
        case .surface: return theme.colors.surface
        case .custom(let bg, _): return bg
        }
    }

    @ViewBuilder
    private var tagBackground: some View {
        if reduceTransparency {
            Capsule().fill(tintColor)
        } else {
            Capsule().fill(.clear)
                .glassEffect(.regular.tint(tintColor))
        }
    }
}

// MARK: - LGTagStyle

/// Semantic color styles for ``LGTag``.
public enum LGTagStyle {
    /// Uses the theme's accent color — for highlights and live indicators.
    case accent
    /// Uses the theme's destructive color — for errors, warnings, overdue states.
    case destructive
    /// Uses the theme's surface color — neutral tags and categories.
    case surface
    /// Custom background + foreground colors.
    case custom(Color, foreground: Color)
}

// MARK: - Preview

#Preview("Tags") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                LGTag("Live", systemImage: "circle.fill", style: .accent)
                LGTag("Overdue", style: .destructive)
                LGTag("Completed", style: .surface)
            }
            HStack(spacing: 8) {
                LGTag("New", style: .accent)
                LGTag("Sale", systemImage: "tag.fill", style: .accent)
            }
        }
        .padding()
    }
}
