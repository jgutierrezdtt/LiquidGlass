// LGListRow.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGListRowContent

/// Content slot protocol for ``LGListRow``.
///
/// Conform your data model or view model to this protocol to drive a list row.
public protocol LGListRowContent {
    /// View rendered in the leading slot (icon, avatar, thumbnail).
    associatedtype LeadingView: View
    /// View rendered in the trailing slot (badge, disclosure, stat).
    associatedtype TrailingView: View

    /// Primary text displayed at the top.
    var title: LocalizedStringKey { get }
    /// Optional secondary text below the title.
    var subtitle: LocalizedStringKey? { get }
    /// `@ViewBuilder` leading accessory view.
    @ViewBuilder var leadingView: LeadingView { get }
    /// `@ViewBuilder` trailing accessory view.
    @ViewBuilder var trailingView: TrailingView { get }
}

// MARK: - LGListRow

/// A generic list row molecule built from an ``LGListRowContent`` content slot.
///
/// ```swift
/// List(items) { item in
///     LGListRow(content: item)
/// }
/// ```
public struct LGListRow<Content: LGListRowContent>: View {

    @Environment(\.lgTheme) private var theme

    private let content: Content
    private let onTap: (() -> Void)?

    /// Creates an ``LGListRow``.
    /// - Parameters:
    ///   - content: The data/content for this row.
    ///   - onTap: Optional tap handler. When provided, the row becomes interactive.
    public init(content: Content, onTap: (() -> Void)? = nil) {
        self.content = content
        self.onTap = onTap
    }

    public var body: some View {
        rowBody
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityDescription)
            .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    @ViewBuilder
    private var rowBody: some View {
        if let action = onTap {
            Button(action: action) { rowContent }
                .buttonStyle(.plain)
        } else {
            rowContent
        }
    }

    private var rowContent: some View {
        HStack(spacing: LGSpacing.md) {
            content.leadingView
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(content.title)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
                    .lineLimit(1)

                if let subtitle = content.subtitle {
                    Text(subtitle)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            content.trailingView
                .accessibilityHidden(true)
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
    }

    private var accessibilityDescription: Text {
        var desc = Text(content.title)
        if let subtitle = content.subtitle {
            desc = desc + Text(", ") + Text(subtitle)
        }
        return desc
    }
}

// MARK: - Preview

private struct PreviewRowContent: LGListRowContent {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let icon: String
    let badge: Int

    var leadingView: some View {
        LGAvatar(initials: "JG", size: .medium)
    }

    var trailingView: some View {
        if badge > 0 {
            LGBadge(.count(badge))
        } else {
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}

#Preview("List Row") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        VStack(spacing: 0) {
            LGListRow(content: PreviewRowContent(title: "Jesús Gutiérrez", subtitle: "Last seen now", icon: "person", badge: 3))
            Divider()
            LGListRow(content: PreviewRowContent(title: "Account Settings", subtitle: nil, icon: "gear", badge: 0))
        }
        .padding()
    }
}
