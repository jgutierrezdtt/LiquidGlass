// LGGameHomeView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGGameHomeContent

/// Content slot protocol for ``LGGameHomeView``.
public protocol LGGameHomeContent {
    associatedtype HeroView: View
    associatedtype StatsRowView: View
    associatedtype ActionButtonsView: View
    associatedtype RecentActivityView: View

    @ViewBuilder var heroView: HeroView { get }
    @ViewBuilder var statsRowView: StatsRowView { get }
    @ViewBuilder var actionButtonsView: ActionButtonsView { get }
    @ViewBuilder var recentActivityView: RecentActivityView { get }

    var screenTitle: LocalizedStringKey { get }
    var playerName: LocalizedStringKey { get }
}

// MARK: - LGGameHomeView

/// A gaming home template: hero banner, player stats, quick play actions, and recent activity.
public struct LGGameHomeView<Content: LGGameHomeContent>: View {

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
                    content.heroView

                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            content.statsRowView
                            content.actionButtonsView
                        }
                        .padding(.horizontal, LGSpacing.md)
                    }

                    content.recentActivityView
                }
                .padding(.top, LGSpacing.md)
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle(content.screenTitle)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview

private struct GamePreviewContent: LGGameHomeContent {
    var heroView: some View {
        LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(height: 240)
            .overlay {
                VStack {
                    Text("Welcome back,")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("Player One")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
            }
    }

    var statsRowView: some View {
        HStack(spacing: LGSpacing.xl) {
            LGStatLabel(value: "1,240", label: "Score")
            LGStatLabel(value: "42", label: "Level")
            LGStatLabel(value: "98%", label: "Win rate", trend: .up("+2%"))
        }
        .padding(.vertical, LGSpacing.sm)
    }

    var actionButtonsView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            HStack(spacing: LGSpacing.sm) {
                LGButton("Play Now", style: .glassProminent) {}
                LGButton("Multiplayer", style: .glass) {}
            }
        }
    }

    var recentActivityView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.sm) {
            Text("Recent Matches")
                .font(.headline)
                .padding(.horizontal, LGSpacing.md)
            Text("No recent matches yet.")
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(.horizontal, LGSpacing.md)
        }
    }

    var screenTitle: LocalizedStringKey { "Game" }
    var playerName: LocalizedStringKey { "Player One" }
}

#Preview("Game Home") {
    LGGameHomeView(content: GamePreviewContent())
}

#Preview("Game Home — Reduce Transparency") {
    LGGameHomeView(content: GamePreviewContent())
        .lgPreviewReduceTransparency()
}
