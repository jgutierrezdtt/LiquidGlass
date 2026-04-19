// LGLeagueStandingsView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGLeagueStandingsContent

/// Content slot protocol for ``LGLeagueStandingsView``.
public protocol LGLeagueStandingsContent {
    associatedtype HeaderView: View
    associatedtype StandingsListView: View
    associatedtype LiveScoresView: View

    @ViewBuilder var headerView: HeaderView { get }
    @ViewBuilder var standingsListView: StandingsListView { get }
    @ViewBuilder var liveScoresView: LiveScoresView { get }

    var screenTitle: LocalizedStringKey { get }
    var hasLiveGames: Bool { get }
}

// MARK: - LGLeagueStandingsView

/// A sports league standings template: header, live scores strip, and standings table.
public struct LGLeagueStandingsView<Content: LGLeagueStandingsContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content

    public init(content: Content) {
        self.content = content
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LGSpacing.lg) {
                    content.headerView

                    if content.hasLiveGames {
                        VStack(alignment: .leading, spacing: LGSpacing.sm) {
                            HStack(spacing: LGSpacing.xs) {
                                Text("lg.sports.live", bundle: .lg)
                                    .font(theme.typography.headline)
                                    .foregroundStyle(theme.colors.onSurface)
                                LGTag("lg.sports.live", systemImage: "circle.fill", style: .accent)
                            }
                            .padding(.horizontal, LGSpacing.md)

                            content.liveScoresView
                        }
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("lg.sports.standings.title", bundle: .lg)
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        // Column headers
                        HStack(spacing: LGSpacing.md) {
                            Text("#").frame(width: 24, alignment: .center)
                            Text("Team")
                            Spacer()
                            HStack(spacing: LGSpacing.lg) {
                                Text("W").frame(width: 28, alignment: .center)
                                Text("L").frame(width: 28, alignment: .center)
                                Text("Pts").frame(width: 36, alignment: .center)
                            }
                        }
                        .font(theme.typography.label.weight(.semibold))
                        .foregroundStyle(theme.colors.secondary)
                        .padding(.horizontal, LGSpacing.md)

                        content.standingsListView
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct StandingsPreviewContent: LGLeagueStandingsContent {
    var headerView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                Text("La Liga 2025/26")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                Text("Matchday 28")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var standingsListView: some View {
        VStack(spacing: 0) {
            LGLeagueRow(rank: 1, teamName: "Real Madrid", points: 75, wins: 24, losses: 3, isHighlighted: true)
            Divider()
            LGLeagueRow(rank: 2, teamName: "Barcelona", points: 68, wins: 21, losses: 4)
            Divider()
            LGLeagueRow(rank: 3, teamName: "Atlético Madrid", points: 60, wins: 18, losses: 6)
        }
    }

    var liveScoresView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LGSpacing.md) {
                LGCard(.compact) {
                    LGScoreRow(homeTeam: "Real Madrid", awayTeam: "Barcelona", homeScore: 2, awayScore: 1, status: "75'", isLive: true)
                }
                .frame(width: 220)
            }
            .padding(.horizontal, LGSpacing.md)
        }
    }

    var screenTitle: LocalizedStringKey { "lg.sports.standings.title" }
    var hasLiveGames: Bool { true }
}

#Preview("League Standings") {
    LGLeagueStandingsView(content: StandingsPreviewContent())
}

#Preview("League Standings — Reduce Transparency") {
    LGLeagueStandingsView(content: StandingsPreviewContent())
        .lgPreviewReduceTransparency()
}
