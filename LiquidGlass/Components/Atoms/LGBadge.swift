// LGBadge.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBadge

/// A small numeric or text overlay indicator (notification count, status dot).
///
/// Attach to any view using the `.lgBadge(_:)` modifier, or use standalone.
///
/// ```swift
/// LGIconButton("bell", label: "Notifications") {}
///     .lgBadge(3)
/// ```
public struct LGBadge: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let value: LGBadgeValue

    /// Creates an ``LGBadge``.
    /// - Parameter value: The badge content (count, dot, or text).
    public init(_ value: LGBadgeValue) {
        self.value = value
    }

    public var body: some View {
        badgeLabel
            .font(theme.typography.label.weight(.bold))
            .foregroundStyle(theme.colors.onPrimary)
            .padding(.horizontal, value.isNumber ? LGSpacing.xs : LGSpacing.xs / 2)
            .frame(minWidth: 18, minHeight: 18)
            .background(badgeBackground)
            .accessibilityLabel(value.accessibilityDescription)
    }

    @ViewBuilder
    private var badgeLabel: some View {
        switch value {
        case .count(let n):
            Text(n > 99 ? "99+" : "\(n)")
        case .dot:
            Circle().frame(width: 8, height: 8)
        case .label(let key):
            Text(key)
        }
    }

    @ViewBuilder
    private var badgeBackground: some View {
        if reduceTransparency {
            Capsule().fill(theme.colors.accent)
        } else {
            Capsule().fill(theme.colors.accent)
                .glassEffect(.regular.tint(theme.colors.accent))
        }
    }
}

// MARK: - LGBadgeValue

/// The content type for an ``LGBadge``.
public enum LGBadgeValue {
    /// A numeric count (e.g., notification count).
    case count(Int)
    /// A small dot indicator (e.g., unread status).
    case dot
    /// A short localized text label.
    case label(LocalizedStringKey)

    var isNumber: Bool {
        if case .count = self { return true }
        return false
    }

    var accessibilityDescription: Text {
        switch self {
        case .count(let n): Text("\(n) notifications")
        case .dot: Text("Unread")
        case .label(let key): Text(key)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Overlays an ``LGBadge`` at the top-trailing corner of this view.
    /// - Parameter value: The badge content.
    func lgBadge(_ value: LGBadgeValue) -> some View {
        overlay(alignment: .topTrailing) {
            LGBadge(value)
                .offset(x: LGSpacing.xs, y: -LGSpacing.xs)
        }
    }

    /// Overlays a numeric ``LGBadge``.
    /// - Parameter count: The count to display. Pass `0` to show no badge.
    func lgBadge(_ count: Int) -> some View {
        Group {
            if count > 0 {
                lgBadge(.count(count))
            } else {
                self
            }
        }
    }
}

// MARK: - Preview

#Preview("Badges") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        GlassEffectContainer(spacing: 20) {
            HStack(spacing: 20) {
                LGIconButton("bell.fill", label: "Notifications") {}
                    .lgBadge(3)
                LGIconButton("message.fill", label: "Messages") {}
                    .lgBadge(.dot)
                LGIconButton("envelope.fill", label: "Email") {}
                    .lgBadge(.label("lg.badge.new"))
            }
        }
        .padding()
    }
}
