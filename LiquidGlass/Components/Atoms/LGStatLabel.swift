// LGStatLabel.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGStatLabel

/// A large-number statistic display atom for dashboards.
///
/// Shows a prominent numeric value, a descriptor label, and an optional trend indicator.
/// Common in banking, analytics, sports, and shopping dashboard templates.
///
/// ```swift
/// LGStatLabel(
///     value: "$4,820.00",
///     label: "Total Balance",
///     trend: .up("+12.4%")
/// )
/// ```
public struct LGStatLabel: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let value: String
    private let label: LocalizedStringKey
    private let trend: LGTrend?

    // MARK: Init

    /// Creates an ``LGStatLabel``.
    /// - Parameters:
    ///   - value: The formatted numeric or text value to display prominently.
    ///   - label: A localized descriptor label shown below the value.
    ///   - trend: Optional trend indicator (up / down / neutral).
    public init(
        value: String,
        label: LocalizedStringKey,
        trend: LGTrend? = nil
    ) {
        self.value = value
        self.label = label
        self.trend = trend
    }

    // MARK: Body

    public var body: some View {
        VStack(alignment: .leading, spacing: LGSpacing.xs) {
            Text(value)
                .font(theme.typography.display)
                .fontWeight(.bold)
                .foregroundStyle(theme.colors.onSurface)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            HStack(spacing: LGSpacing.xs) {
                Text(label)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.secondary)

                if let trend {
                    trendView(trend)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    // MARK: Private

    @ViewBuilder
    private func trendView(_ trend: LGTrend) -> some View {
        HStack(spacing: 2) {
            Image(systemName: trend.systemImage)
                .font(theme.typography.label)
                .accessibilityHidden(true)
            Text(trend.text)
                .font(theme.typography.label.weight(.semibold))
        }
        .foregroundStyle(trend.color(theme: theme))
        .transition(reduceMotion ? .identity : LGTransitions.scaleIn)
    }

    private var accessibilityDescription: Text {
        var desc = Text(value) + Text(" ") + Text(label)
        if let trend {
            desc = desc + Text(" ") + Text(trend.accessibilityDescription)
        }
        return desc
    }
}

// MARK: - LGTrend

/// A directional trend indicator for ``LGStatLabel``.
public enum LGTrend {
    /// Positive trend with a display string (e.g., "+12.4%").
    case up(String)
    /// Negative trend with a display string (e.g., "-3.1%").
    case down(String)
    /// Neutral / unchanged trend with a display string.
    case neutral(String)

    var text: String {
        switch self { case .up(let s), .down(let s), .neutral(let s): return s }
    }

    var systemImage: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .neutral: return "arrow.right"
        }
    }

    func color(theme: any LGThemeProtocol) -> Color {
        switch self {
        case .up: return Color.green
        case .down: return theme.colors.destructive
        case .neutral: return theme.colors.secondary
        }
    }

    var accessibilityDescription: String {
        switch self {
        case .up(let s): return "Up \(s)"
        case .down(let s): return "Down \(s)"
        case .neutral(let s): return "Unchanged \(s)"
        }
    }
}

// MARK: - Preview

#Preview("Stat Labels") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        VStack(alignment: .leading, spacing: LGSpacing.xl) {
            LGStatLabel(value: "$4,820.00", label: "lg.banking.balance.label", trend: .up("+12.4%"))
            LGStatLabel(value: "1,234", label: "Total users", trend: .down("-3.1%"))
            LGStatLabel(value: "98.5%", label: "Completion rate", trend: .neutral("±0%"))
            LGStatLabel(value: "42", label: "Achievements")
        }
        .padding()
    }
}
