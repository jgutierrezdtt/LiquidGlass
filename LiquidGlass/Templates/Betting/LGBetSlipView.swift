// LGBetSlipView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBetSlipContent

/// Content slot protocol for ``LGBetSlipView``.
public protocol LGBetSlipContent {
    associatedtype SelectionsView: View
    associatedtype OddsDisplayView: View

    @ViewBuilder var selectionsView: SelectionsView { get }
    @ViewBuilder var oddsDisplayView: OddsDisplayView { get }

    var screenTitle: LocalizedStringKey { get }
    var totalOdds: String { get }
    var potentialReturn: String { get }
    var stakeBinding: Binding<String> { get }
    var onPlaceBet: () -> Void { get }
    var canSubmit: Bool { get }
}

// MARK: - LGBetSlipView

/// A betting slip template: selections, odds, stake input, potential return, and place-bet CTA.
public struct LGBetSlipView<Content: LGBetSlipContent>: View {

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
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: LGSpacing.lg) {
                        // Selections
                        VStack(alignment: .leading, spacing: LGSpacing.sm) {
                            Text("Selections")
                                .font(theme.typography.headline)
                                .foregroundStyle(theme.colors.onSurface)
                                .padding(.horizontal, LGSpacing.md)
                            content.selectionsView
                                .padding(.horizontal, LGSpacing.md)
                        }

                        // Odds display
                        GlassEffectContainer(spacing: LGSpacing.md) {
                            content.oddsDisplayView
                                .padding(.horizontal, LGSpacing.md)
                                .padding(.vertical, LGSpacing.sm)
                        }
                        .padding(.horizontal, LGSpacing.md)
                    }
                    .padding(.top, LGSpacing.md)
                    .padding(.bottom, LGSpacing.lg)
                }

                // Sticky footer
                GlassEffectContainer(spacing: LGSpacing.md) {
                    VStack(spacing: LGSpacing.md) {
                        // Stake input
                        LGTextField(
                            "Stake (e.g. 10.00)",
                            text: content.stakeBinding
                        )

                        // Return summary
                        HStack {
                            Text("Total Odds").font(theme.typography.body).foregroundStyle(theme.colors.secondary)
                            Spacer()
                            Text(content.totalOdds).font(theme.typography.body.weight(.semibold))
                        }
                        HStack {
                            Text("Potential Return").font(theme.typography.body).foregroundStyle(theme.colors.secondary)
                            Spacer()
                            Text(content.potentialReturn).font(theme.typography.headline).foregroundStyle(theme.colors.accent)
                        }

                        // CTA
                        LGButton("Place Bet", style: content.canSubmit ? .glassProminent : .glass, action: content.onPlaceBet)
                            .frame(maxWidth: .infinity)
                            .disabled(!content.canSubmit)
                            .accessibilityHint(Text("Confirms and places the current bet slip"))
                    }
                    .padding(LGSpacing.md)
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.bottom, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct BetSlipPreviewContent: LGBetSlipContent {
    @State var stake = "10.00"

    var selectionsView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    Text("Real Madrid to Win").font(.headline)
                    HStack {
                        LGTag("Full Time Result", style: .surface)
                        Spacer()
                        Text("1.85").font(.title3.bold()).foregroundStyle(.green)
                    }
                }
            }
        }
    }

    var oddsDisplayView: some View {
        HStack(spacing: LGSpacing.xl) {
            LGStatLabel(value: "1.85", label: "Odds")
            LGStatLabel(value: "1", label: "Selections")
        }
    }

    var screenTitle: LocalizedStringKey { "Bet Slip" }
    var totalOdds: String { "1.85" }
    var potentialReturn: String { "$18.50" }
    var stakeBinding: Binding<String> { $stake }
    var onPlaceBet: () -> Void { {} }
    var canSubmit: Bool { !stake.isEmpty }
}

#Preview("Bet Slip") {
    LGBetSlipView(content: BetSlipPreviewContent())
}

#Preview("Bet Slip — Reduce Transparency") {
    LGBetSlipView(content: BetSlipPreviewContent())
        .lgPreviewReduceTransparency()
}
