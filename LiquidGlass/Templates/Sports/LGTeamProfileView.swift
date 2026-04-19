// LGTeamProfileView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTeamProfileContent

/// Content slot protocol for ``LGTeamProfileView``.
public protocol LGTeamProfileContent {
    associatedtype HeroBannerView: View
    associatedtype StatsRowView: View
    associatedtype SquadListView: View
    associatedtype FixturesView: View

    @ViewBuilder var heroBannerView: HeroBannerView { get }
    @ViewBuilder var statsRowView: StatsRowView { get }
    @ViewBuilder var squadListView: SquadListView { get }
    @ViewBuilder var fixturesView: FixturesView { get }

    var teamName: LocalizedStringKey { get }
    var leagueName: LocalizedStringKey { get }
}

// MARK: - LGTeamProfileView

/// A sports team profile template: hero banner, season stats, squad list, and upcoming fixtures.
public struct LGTeamProfileView<Content: LGTeamProfileContent>: View {

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
                    // Hero
                    LGHeroDetail(content: TeamHeroAdapter(inner: content))

                    // Season stats
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        content.statsRowView
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Squad
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Squad")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.squadListView
                    }

                    // Fixtures
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Upcoming Fixtures")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.fixturesView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
        }
    }
}

// MARK: - Internal adapter for LGHeroDetail

private struct TeamHeroAdapter<Inner: LGTeamProfileContent>: LGHeroDetailContent {
    let inner: Inner

    var heroView: some View { inner.heroBannerView }
    var bodyView: some View { EmptyView() }
    var actionsView: some View {
        LGToolbarGroup {
            LGIconButton("heart", label: "Follow Team") {}
            LGIconButton("square.and.arrow.up", label: "Share") {}
        }
    }
    var navigationTitle: LocalizedStringKey { inner.teamName }
}

// MARK: - Preview

private struct TeamProfilePreviewContent: LGTeamProfileContent {
    var heroBannerView: some View {
        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Text("RM")
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(.white.opacity(0.3))
            }
    }

    var statsRowView: some View {
        HStack(spacing: LGSpacing.xl) {
            LGStatLabel(value: "24", label: "Wins")
            LGStatLabel(value: "3", label: "Losses")
            LGStatLabel(value: "75", label: "Points", trend: .up("+8"))
        }
    }

    var squadListView: some View {
        VStack(spacing: LGSpacing.sm) {
            ForEach(["Benzema", "Modric", "Kroos"], id: \.self) { name in
                HStack(spacing: LGSpacing.md) {
                    LGAvatar(initials: String(name.prefix(2)), size: .small)
                    Text(name).font(.body)
                    Spacer()
                    LGTag("FW", style: .surface)
                }
                .padding(.horizontal, LGSpacing.md)
            }
        }
    }

    var fixturesView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                LGScoreRow(homeTeam: "Real Madrid", awayTeam: "Atlético", status: "Sat 20:00")
            }
        }
    }

    var teamName: LocalizedStringKey { "Real Madrid" }
    var leagueName: LocalizedStringKey { "La Liga" }
}

#Preview("Team Profile") {
    LGTeamProfileView(content: TeamProfilePreviewContent())
}

#Preview("Team Profile — Reduce Transparency") {
    LGTeamProfileView(content: TeamProfilePreviewContent())
        .lgPreviewReduceTransparency()
}
