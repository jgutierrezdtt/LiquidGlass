// LGEventsListView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGEventsListContent

/// Content slot protocol for ``LGEventsListView``.
public protocol LGEventsListContent {
    associatedtype FiltersView: View
    associatedtype EventsView: View
    associatedtype BetSlipPreviewView: View

    @ViewBuilder var filtersView: FiltersView { get }
    @ViewBuilder var eventsView: EventsView { get }
    @ViewBuilder var betSlipPreviewView: BetSlipPreviewView { get }

    var screenTitle: LocalizedStringKey { get }
    var activeBetsCount: Int { get }
}

// MARK: - LGEventsListView

/// A betting events list template: filters strip, event cards, and floating bet-slip preview.
public struct LGEventsListView<Content: LGEventsListContent>: View {

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
                    ScrollView(.horizontal, showsIndicators: false) {
                        content.filtersView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    content.eventsView
                        .padding(.horizontal, LGSpacing.md)
                }
                .padding(.top, LGSpacing.md)
            }
            .safeAreaInset(edge: .bottom) {
                if content.activeBetsCount > 0 {
                    content.betSlipPreviewView
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.bottom, LGSpacing.sm)
                        .transition(.opacity)
                }
            }
            .animation(LGAnimations.snappy, value: content.activeBetsCount)
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct BettingPreviewContent: LGEventsListContent {
    var filtersView: some View {
        HStack(spacing: LGSpacing.sm) {
            LGTag("Football", style: .accent)
            LGTag("Basketball", style: .surface)
            LGTag("Tennis", style: .surface)
            LGTag("Baseball", style: .surface)
        }
    }

    var eventsView: some View {
        VStack(spacing: LGSpacing.sm) {
            GlassEffectContainer(spacing: LGSpacing.sm) {
                VStack(spacing: LGSpacing.sm) {
                    LGCard(.compact) {
                        LGScoreRow(homeTeam: "Real Madrid", awayTeam: "Barcelona", status: "Today 20:00", isLive: false)
                    }
                    LGCard(.compact) {
                        LGScoreRow(homeTeam: "Man City", awayTeam: "Arsenal", status: "Tomorrow 18:30", isLive: false)
                    }
                }
            }
        }
    }

    var betSlipPreviewView: some View {
        LGCard(.compact) {
            HStack {
                Text("Bet Slip")
                    .font(.headline)
                Spacer()
                LGBadge(.count(activeBetsCount))
                LGButton("Place Bet", style: .glassProminent) {}
            }
        }
    }

    var screenTitle: LocalizedStringKey { "Events" }
    var activeBetsCount: Int { 2 }
}

#Preview("Events List") {
    LGEventsListView(content: BettingPreviewContent())
}

#Preview("Events List — Reduce Transparency") {
    LGEventsListView(content: BettingPreviewContent())
        .lgPreviewReduceTransparency()
}
