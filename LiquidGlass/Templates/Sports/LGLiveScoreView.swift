// LGLiveScoreView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGLiveScoreContent

/// Content slot protocol for ``LGLiveScoreView``.
public protocol LGLiveScoreContent {
    associatedtype LiveMatchesView: View
    associatedtype ScheduledMatchesView: View
    associatedtype CompletedMatchesView: View

    @ViewBuilder var liveMatchesView: LiveMatchesView { get }
    @ViewBuilder var scheduledMatchesView: ScheduledMatchesView { get }
    @ViewBuilder var completedMatchesView: CompletedMatchesView { get }

    var screenTitle: LocalizedStringKey { get }
    var liveCount: Int { get }
}

// MARK: - LGLiveScoreView

/// A live scores template: live ticker, scheduled, and completed matches in separate sections.
public struct LGLiveScoreView<Content: LGLiveScoreContent>: View {

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
                    // Live now
                    if content.liveCount > 0 {
                        VStack(alignment: .leading, spacing: LGSpacing.sm) {
                            HStack(spacing: LGSpacing.sm) {
                                Image(systemName: "circle.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                                    .accessibilityHidden(true)
                                Text("lg.sports.live")
                                    .font(theme.typography.headline)
                                    .foregroundStyle(theme.colors.onSurface)
                                LGBadge(.count(content.liveCount))
                            }
                            .padding(.horizontal, LGSpacing.md)
                            content.liveMatchesView
                                .padding(.horizontal, LGSpacing.md)
                        }
                    }

                    // Scheduled
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Upcoming")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.scheduledMatchesView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // Completed
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Results")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.completedMatchesView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct LiveScorePreviewContent: LGLiveScoreContent {
    var liveMatchesView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.hero) {
                LGScoreRow(homeTeam: "Real Madrid", awayTeam: "Barcelona", homeScore: 2, awayScore: 1, status: "73'", isLive: true)
            }
        }
    }

    var scheduledMatchesView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                LGScoreRow(homeTeam: "Bayern", awayTeam: "Dortmund", status: "Sat 18:30")
            }
        }
    }

    var completedMatchesView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                LGScoreRow(homeTeam: "Chelsea", awayTeam: "Arsenal", homeScore: 1, awayScore: 1, status: "FT")
            }
        }
    }

    var screenTitle: LocalizedStringKey { "Live Scores" }
    var liveCount: Int { 1 }
}

#Preview("Live Scores") {
    LGLiveScoreView(content: LiveScorePreviewContent())
}

#Preview("Live Scores — Reduce Transparency") {
    LGLiveScoreView(content: LiveScorePreviewContent())
        .lgPreviewReduceTransparency()
}
