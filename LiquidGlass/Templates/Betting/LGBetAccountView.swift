// LGBetAccountView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBetAccountContent

/// Content slot protocol for ``LGBetAccountView``.
public protocol LGBetAccountContent {
    associatedtype BalanceCardView: View
    associatedtype QuickActionsView: View
    associatedtype BetHistoryView: View

    @ViewBuilder var balanceCardView: BalanceCardView { get }
    @ViewBuilder var quickActionsView: QuickActionsView { get }
    @ViewBuilder var betHistoryView: BetHistoryView { get }

    var screenTitle: LocalizedStringKey { get }
}

// MARK: - LGBetAccountView

/// A betting account overview template: balance, quick actions (deposit/withdraw), and bet history.
public struct LGBetAccountView<Content: LGBetAccountContent>: View {

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
                    // Balance card
                    content.balanceCardView
                        .padding(.horizontal, LGSpacing.md)

                    // Quick actions
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        content.quickActionsView
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Bet history
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Bet History")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.betHistoryView
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

private struct BetAccountPreviewContent: LGBetAccountContent {
    var balanceCardView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                Text("Available Balance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("$250.00")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                HStack(spacing: LGSpacing.sm) {
                    LGStatLabel(value: "+$45", label: "Won today", trend: .up("+$45"))
                    LGStatLabel(value: "3", label: "Active bets")
                }
            }
        }
    }

    var quickActionsView: some View {
        HStack(spacing: LGSpacing.md) {
            LGButton("Deposit", systemImage: "plus.circle", style: .glassProminent) {}
                .frame(maxWidth: .infinity)
                .accessibilityHint(Text("Opens deposit funds screen"))
            LGButton("Withdraw", systemImage: "arrow.down.circle", style: .glass) {}
                .frame(maxWidth: .infinity)
                .accessibilityHint(Text("Opens withdraw funds screen"))
        }
    }

    var betHistoryView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                HStack {
                    VStack(alignment: .leading, spacing: LGSpacing.xs) {
                        Text("Real Madrid to Win").font(.headline)
                        Text("Settled · 22 Apr").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    LGTag("Won", style: .custom(.green, foreground: .white))
                }
            }
            LGCard(.compact) {
                HStack {
                    VStack(alignment: .leading, spacing: LGSpacing.xs) {
                        Text("Over 2.5 Goals").font(.headline)
                        Text("Settled · 20 Apr").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    LGTag("Lost", style: .destructive)
                }
            }
        }
    }

    var screenTitle: LocalizedStringKey { "My Account" }
}

#Preview("Bet Account") {
    LGBetAccountView(content: BetAccountPreviewContent())
}

#Preview("Bet Account — Reduce Transparency") {
    LGBetAccountView(content: BetAccountPreviewContent())
        .lgPreviewReduceTransparency()
}
