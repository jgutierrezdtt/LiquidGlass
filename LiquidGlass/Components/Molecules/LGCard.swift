// LGCard.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGCard

/// A glass card molecule with multiple layout variants and `@ViewBuilder` content slots.
///
/// Place multiple ``LGCard`` views inside a `GlassEffectContainer` for morphing effects.
///
/// ```swift
/// GlassEffectContainer(spacing: 12) {
///     VStack(spacing: 12) {
///         LGCard(.hero) {
///             MyHeroContent()
///         }
///         LGCard(.compact) {
///             MyCompactContent()
///         }
///     }
/// }
/// ```
public struct LGCard<Content: View>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let variant: LGCardVariant
    private let content: Content

    // MARK: Init

    /// Creates an ``LGCard``.
    /// - Parameters:
    ///   - variant: The layout variant controlling padding and corner radius.
    ///   - content: `@ViewBuilder` content placed inside the card.
    public init(
        _ variant: LGCardVariant = .info,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.content = content()
    }

    // MARK: Body

    public var body: some View {
        content
            .padding(variant.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
    }

    // MARK: Private

    @ViewBuilder
    private var cardBackground: some View {
        if reduceTransparency {
            LGShape.rounded(variant.shapeSize)
                .fill(theme.colors.surface.opacity(0.92))
        } else {
            LGShape.rounded(variant.shapeSize)
                .fill(.clear)
                .glassEffect(in: .rect(cornerRadius: .lgRadius(variant.shapeSize)))
        }
    }
}

// MARK: - LGCardVariant

/// Layout variants for ``LGCard``.
public enum LGCardVariant {
    /// Full-bleed hero card with large padding — for featured content and dashboard headers.
    case hero
    /// Compact card with reduced padding — for list-like stacked layouts.
    case compact
    /// Standard informational card with balanced padding.
    case info
    /// Stats dashboard card with extra horizontal breathing room.
    case stat

    var padding: EdgeInsets {
        switch self {
        case .hero: return EdgeInsets(top: LGSpacing.xl, leading: LGSpacing.lg, bottom: LGSpacing.xl, trailing: LGSpacing.lg)
        case .compact: return EdgeInsets(top: LGSpacing.sm, leading: LGSpacing.md, bottom: LGSpacing.sm, trailing: LGSpacing.md)
        case .info: return EdgeInsets(top: LGSpacing.md, leading: LGSpacing.md, bottom: LGSpacing.md, trailing: LGSpacing.md)
        case .stat: return EdgeInsets(top: LGSpacing.lg, leading: LGSpacing.xl, bottom: LGSpacing.lg, trailing: LGSpacing.xl)
        }
    }

    var shapeSize: LGShapeSize {
        switch self {
        case .hero: return .xl
        case .compact: return .sm
        case .info: return .md
        case .stat: return .lg
        }
    }
}

// MARK: - Preview

#Preview("Cards") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        ScrollView {
            GlassEffectContainer(spacing: 12) {
                VStack(spacing: 12) {
                    LGCard(.hero) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Balance")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("$4,820.00")
                                .font(.largeTitle.bold())
                        }
                    }
                    LGCard(.info) {
                        Text("Info card content goes here.")
                    }
                    LGCard(.compact) {
                        Text("Compact row")
                    }
                }
                .padding()
            }
        }
    }
}
