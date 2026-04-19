// LGDomainRows.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTransactionRow

/// A list row molecule for banking transaction items.
///
/// ```swift
/// LGTransactionRow(
///     title: "Coffee",
///     subtitle: "Today, 9:30 AM",
///     amount: "-$4.50",
///     isDebit: true,
///     icon: "cup.and.saucer.fill"
/// )
/// ```
public struct LGTransactionRow: View {

    @Environment(\.lgTheme) private var theme

    public let title: LocalizedStringKey
    public let subtitle: LocalizedStringKey?
    public let amount: String
    public let isDebit: Bool
    public let icon: String

    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        amount: String,
        isDebit: Bool,
        icon: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.isDebit = isDebit
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: LGSpacing.md) {
            Image(systemName: icon)
                .font(theme.typography.body)
                .frame(width: 40, height: 40)
                .foregroundStyle(theme.colors.onSurface)
                .lgGlassCard(.sm)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(title)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
                if let subtitle {
                    Text(subtitle)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                }
            }

            Spacer()

            Text(amount)
                .font(theme.typography.body.weight(.semibold))
                .foregroundStyle(isDebit ? theme.colors.destructive : Color.green)
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - LGScoreRow

/// A list row molecule for sports score items.
public struct LGScoreRow: View {

    @Environment(\.lgTheme) private var theme

    public let homeTeam: LocalizedStringKey
    public let awayTeam: LocalizedStringKey
    public let homeScore: Int?
    public let awayScore: Int?
    public let status: LocalizedStringKey
    public let isLive: Bool

    public init(
        homeTeam: LocalizedStringKey,
        awayTeam: LocalizedStringKey,
        homeScore: Int? = nil,
        awayScore: Int? = nil,
        status: LocalizedStringKey,
        isLive: Bool = false
    ) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.status = status
        self.isLive = isLive
    }

    public var body: some View {
        HStack(spacing: LGSpacing.md) {
            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(homeTeam)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
                Text(awayTeam)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
            }

            Spacer()

            if let home = homeScore, let away = awayScore {
                VStack(spacing: LGSpacing.xs) {
                    Text("\(home)")
                    Text("\(away)")
                }
                .font(theme.typography.body.weight(.bold))
                .foregroundStyle(theme.colors.onSurface)
            }

            VStack(alignment: .trailing, spacing: LGSpacing.xs) {
                if isLive {
                    LGTag("lg.sports.live", systemImage: "circle.fill", style: .accent)
                }
                Text(status)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.secondary)
            }
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - LGProductRow

/// A list row molecule for shopping product items.
public struct LGProductRow: View {

    @Environment(\.lgTheme) private var theme

    public let title: LocalizedStringKey
    public let subtitle: LocalizedStringKey?
    public let price: String
    public let image: Image?
    public let onAddToCart: () -> Void

    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        price: String,
        image: Image? = nil,
        onAddToCart: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.image = image
        self.onAddToCart = onAddToCart
    }

    public var body: some View {
        HStack(spacing: LGSpacing.md) {
            if let img = image {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(LGShape.rounded(.sm))
                    .accessibilityHidden(true)
            } else {
                LGShape.rounded(.sm)
                    .fill(theme.colors.surface)
                    .frame(width: 56, height: 56)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(title)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
                    .lineLimit(1)
                if let subtitle {
                    Text(subtitle)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                        .lineLimit(1)
                }
                Text(price)
                    .font(theme.typography.body.weight(.bold))
                    .foregroundStyle(theme.colors.primary)
            }

            Spacer()

            LGIconButton("plus.circle.fill", label: "lg.shopping.add.to.cart", size: .small) {
                onAddToCart()
            }
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - LGLessonRow

/// A list row molecule for learning / course lesson items.
public struct LGLessonRow: View {

    @Environment(\.lgTheme) private var theme

    public let title: LocalizedStringKey
    public let duration: LocalizedStringKey?
    public let progress: Double      // 0.0 … 1.0
    public let isCompleted: Bool

    public init(
        title: LocalizedStringKey,
        duration: LocalizedStringKey? = nil,
        progress: Double = 0,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.duration = duration
        self.progress = progress
        self.isCompleted = isCompleted
    }

    public var body: some View {
        HStack(spacing: LGSpacing.md) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "play.circle")
                .font(theme.typography.title)
                .foregroundStyle(isCompleted ? Color.green : theme.colors.primary)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(title)
                    .font(theme.typography.body.weight(.medium))
                    .foregroundStyle(theme.colors.onSurface)
                    .lineLimit(1)
                if let duration {
                    Text(duration)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                }
                if !isCompleted && progress > 0 {
                    LGProgressBar(value: progress, height: 4)
                }
            }

            Spacer()
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - LGLeagueRow

/// A list row molecule for sports league standings.
public struct LGLeagueRow: View {

    @Environment(\.lgTheme) private var theme

    public let rank: Int
    public let teamName: LocalizedStringKey
    public let points: Int
    public let wins: Int
    public let losses: Int
    public let isHighlighted: Bool

    public init(
        rank: Int,
        teamName: LocalizedStringKey,
        points: Int,
        wins: Int,
        losses: Int,
        isHighlighted: Bool = false
    ) {
        self.rank = rank
        self.teamName = teamName
        self.points = points
        self.wins = wins
        self.losses = losses
        self.isHighlighted = isHighlighted
    }

    public var body: some View {
        HStack(spacing: LGSpacing.md) {
            Text("\(rank)")
                .font(theme.typography.body.weight(.bold))
                .foregroundStyle(isHighlighted ? theme.colors.accent : theme.colors.secondary)
                .frame(width: 24, alignment: .center)

            Text(teamName)
                .font(theme.typography.body.weight(isHighlighted ? .semibold : .regular))
                .foregroundStyle(theme.colors.onSurface)
                .lineLimit(1)

            Spacer()

            HStack(spacing: LGSpacing.lg) {
                Text("\(wins)")
                    .frame(width: 28, alignment: .center)
                Text("\(losses)")
                    .frame(width: 28, alignment: .center)
                Text("\(points)")
                    .fontWeight(.semibold)
                    .frame(width: 36, alignment: .center)
            }
            .font(theme.typography.caption)
            .foregroundStyle(theme.colors.secondary)
        }
        .padding(.vertical, LGSpacing.sm)
        .padding(.horizontal, LGSpacing.md)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Domain Rows") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        ScrollView {
            VStack(spacing: 0) {
                LGTransactionRow(title: "Coffee Shop", subtitle: "Today, 9:30 AM", amount: "-$4.50", isDebit: true, icon: "cup.and.saucer.fill")
                Divider()
                LGScoreRow(homeTeam: "Real Madrid", awayTeam: "Barcelona", homeScore: 2, awayScore: 1, status: "75'", isLive: true)
                Divider()
                LGProductRow(title: "iPhone 17 Pro", subtitle: "Space Black, 256 GB", price: "$1,099", onAddToCart: {})
                Divider()
                LGLessonRow(title: "Swift Concurrency", duration: "18 min", progress: 0.6)
                Divider()
                LGLeagueRow(rank: 1, teamName: "Real Madrid", points: 75, wins: 24, losses: 3, isHighlighted: true)
            }
        }
        .padding()
    }
}
