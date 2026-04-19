// LGLeaderboardView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGLeaderboardContent

/// Content slot protocol for ``LGLeaderboardView``.
public protocol LGLeaderboardContent {
    associatedtype PodiumView: View
    associatedtype RankListView: View
    associatedtype PlayerCardView: View

    @ViewBuilder var podiumView: PodiumView { get }
    @ViewBuilder var rankListView: RankListView { get }
    @ViewBuilder var playerCardView: PlayerCardView { get }

    var screenTitle: LocalizedStringKey { get }
    var playerRank: Int { get }
}

// MARK: - LGLeaderboardView

/// A gaming leaderboard template: top-3 podium, player's own rank card, and full rank list.
public struct LGLeaderboardView<Content: LGLeaderboardContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LGSpacing.lg) {
                    // Podium
                    content.podiumView
                        .padding(.horizontal, LGSpacing.md)

                    // Player's own rank
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Your Rank")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.playerCardView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // Full list
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("All Players")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        // Column headers
                        HStack {
                            Text("#").frame(width: 24, alignment: .center)
                            Text("Player")
                            Spacer()
                            HStack(spacing: LGSpacing.lg) {
                                Text("W").frame(width: 28, alignment: .center)
                                Text("Pts").frame(width: 36, alignment: .center)
                            }
                        }
                        .font(theme.typography.label.weight(.semibold))
                        .foregroundStyle(theme.colors.secondary)
                        .padding(.horizontal, LGSpacing.md)

                        content.rankListView
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct LeaderboardPreviewContent: LGLeaderboardContent {
    var podiumView: some View {
        GlassEffectContainer(spacing: LGSpacing.md) {
            HStack(alignment: .bottom, spacing: LGSpacing.md) {
                // 2nd place
                VStack(spacing: LGSpacing.xs) {
                    LGAvatar(initials: "AB", size: .medium)
                    Text("AB").font(.caption)
                    LGStatLabel(value: "980", label: "Pts")
                    LGTag("2nd", style: .surface)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, LGSpacing.sm)

                // 1st place (taller)
                VStack(spacing: LGSpacing.xs) {
                    Image(systemName: "crown.fill").foregroundStyle(.yellow).accessibilityHidden(true)
                    LGAvatar(initials: "JG", size: .large)
                    Text("JG").font(.caption)
                    LGStatLabel(value: "1,240", label: "Pts")
                    LGTag("1st", style: .accent)
                }
                .frame(maxWidth: .infinity)

                // 3rd place
                VStack(spacing: LGSpacing.xs) {
                    LGAvatar(initials: "MK", size: .medium)
                    Text("MK").font(.caption)
                    LGStatLabel(value: "870", label: "Pts")
                    LGTag("3rd", style: .surface)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, LGSpacing.sm)
            }
            .padding(.vertical, LGSpacing.md)
        }
    }

    var rankListView: some View {
        VStack(spacing: 0) {
            LGLeagueRow(rank: 1, teamName: "JG — Player One", points: 1240, wins: 42, losses: 3, isHighlighted: true)
            Divider()
            LGLeagueRow(rank: 2, teamName: "AB — Player Two", points: 980, wins: 35, losses: 8)
            Divider()
            LGLeagueRow(rank: 3, teamName: "MK — Player Three", points: 870, wins: 30, losses: 12)
        }
    }

    var playerCardView: some View {
        LGCard(.compact) {
            HStack(spacing: LGSpacing.md) {
                LGAvatar(initials: "JG", size: .medium)
                LGStatLabel(value: "#\(playerRank)", label: "Your rank", trend: .up("+3"))
                Spacer()
                LGStatLabel(value: "1,240", label: "Points")
            }
        }
    }

    var screenTitle: LocalizedStringKey { "Leaderboard" }
    var playerRank: Int { 1 }
}

#Preview("Leaderboard") {
    LGLeaderboardView(content: LeaderboardPreviewContent())
}

#Preview("Leaderboard — Reduce Transparency") {
    LGLeaderboardView(content: LeaderboardPreviewContent())
        .lgPreviewReduceTransparency()
}
