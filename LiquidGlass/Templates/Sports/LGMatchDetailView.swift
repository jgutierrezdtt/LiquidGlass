// LGMatchDetailView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGMatchDetailContent

/// Content slot protocol for ``LGMatchDetailView``.
public protocol LGMatchDetailContent {
    associatedtype ScoreHeroView: View
    associatedtype StatsView: View
    associatedtype TimelineView: View
    associatedtype LineupsView: View

    @ViewBuilder var scoreHeroView: ScoreHeroView { get }
    @ViewBuilder var statsView: StatsView { get }
    @ViewBuilder var timelineView: TimelineView { get }
    @ViewBuilder var lineupsView: LineupsView { get }

    var screenTitle: LocalizedStringKey { get }
    var isLive: Bool { get }
}

// MARK: - LGMatchDetailView

/// A sports match detail template: score hero, stats, timeline, and lineups.
public struct LGMatchDetailView<Content: LGMatchDetailContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @State private var selectedTab: MatchTab = .stats
    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LGSpacing.lg) {
                    // Score hero
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            if content.isLive {
                                LGTag("lg.sports.live", systemImage: "circle.fill", style: .accent)
                            }
                            content.scoreHeroView
                        }
                        .padding(.vertical, LGSpacing.md)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Tab picker
                    GlassEffectContainer(spacing: LGSpacing.xs) {
                        HStack(spacing: LGSpacing.xs) {
                            ForEach(MatchTab.allCases, id: \.self) { tab in
                                Button {
                                    withAnimation(LGAnimations.snappy) { selectedTab = tab }
                                } label: {
                                    Text(tab.label)
                                        .font(theme.typography.body)
                                        .padding(.horizontal, LGSpacing.md)
                                        .padding(.vertical, LGSpacing.sm)
                                }
                                .buttonStyle(.glassProminent)
                                .opacity(selectedTab == tab ? 1 : 0.6)
                                .accessibilityLabel(Text(tab.label))
                            }
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Content
                    switch selectedTab {
                    case .stats: content.statsView
                    case .timeline: content.timelineView
                    case .lineups: content.lineupsView
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private enum MatchTab: CaseIterable {
    case stats, timeline, lineups
    var label: LocalizedStringKey {
        switch self { case .stats: "Stats"; case .timeline: "Timeline"; case .lineups: "Lineups" }
    }
}

// MARK: - Preview

private struct MatchDetailPreviewContent: LGMatchDetailContent {
    var scoreHeroView: some View {
        HStack {
            VStack(spacing: LGSpacing.xs) {
                LGAvatar(initials: "RM", size: .large, accessibilityLabel: "Real Madrid")
                Text("Real Madrid").font(.caption)
            }
            Spacer()
            HStack(spacing: LGSpacing.md) {
                Text("2").font(.system(size: 48, weight: .bold))
                Text("–").font(.title).foregroundStyle(.secondary)
                Text("1").font(.system(size: 48, weight: .bold))
            }
            Spacer()
            VStack(spacing: LGSpacing.xs) {
                LGAvatar(initials: "BC", size: .large, accessibilityLabel: "Barcelona")
                Text("Barcelona").font(.caption)
            }
        }
        .padding(.horizontal, LGSpacing.xl)
    }

    var statsView: some View {
        VStack(spacing: LGSpacing.sm) {
            GlassEffectContainer(spacing: LGSpacing.sm) {
                VStack(spacing: LGSpacing.sm) {
                    ForEach([("Possession", "58%", "42%"), ("Shots", "14", "9"), ("Passes", "420", "310")], id: \.0) { stat in
                        HStack {
                            Text(stat.1).font(.body.bold()).frame(width: 50, alignment: .trailing)
                            Spacer()
                            Text(stat.0).font(.caption).foregroundStyle(.secondary)
                            Spacer()
                            Text(stat.2).font(.body.bold()).frame(width: 50, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var timelineView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                HStack {
                    Text("45'").font(.caption.monospaced()).foregroundStyle(.secondary)
                    Text("⚽ Benzema (Real Madrid)")
                }
            }
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var lineupsView: some View {
        Text("Lineups coming soon")
            .font(.body)
            .foregroundStyle(.secondary)
            .padding(.horizontal, LGSpacing.md)
    }

    var screenTitle: LocalizedStringKey { "Match Detail" }
    var isLive: Bool { true }
}

#Preview("Match Detail") {
    LGMatchDetailView(content: MatchDetailPreviewContent())
}

#Preview("Match Detail — Reduce Transparency") {
    LGMatchDetailView(content: MatchDetailPreviewContent())
        .lgPreviewReduceTransparency()
}
