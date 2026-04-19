// LGAccountDetailView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGAccountDetailContent

/// Content slot protocol for ``LGAccountDetailView``.
public protocol LGAccountDetailContent {
    associatedtype HeroCardView: View
    associatedtype StatsGridView: View
    associatedtype RecentTransactionsView: View
    associatedtype ActionsView: View

    @ViewBuilder var heroCardView: HeroCardView { get }
    @ViewBuilder var statsGridView: StatsGridView { get }
    @ViewBuilder var recentTransactionsView: RecentTransactionsView { get }
    @ViewBuilder var actionsView: ActionsView { get }

    var screenTitle: LocalizedStringKey { get }
    var accountNumber: String { get }
}

// MARK: - LGAccountDetailView

/// A banking account detail template: balance hero, stats grid, actions, and recent transactions.
public struct LGAccountDetailView<Content: LGAccountDetailContent>: View {

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
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            content.heroCardView
                            content.actionsView
                        }
                    }

                    content.statsGridView
                        .padding(.horizontal, LGSpacing.md)

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Recent Transactions")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        content.recentTransactionsView
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview

private struct AccountDetailPreviewContent: LGAccountDetailContent {
    var heroCardView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                Text("Checking Account")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                LGStatLabel(value: "$4,820.00", label: "lg.banking.balance.label")
                Text("**** **** **** 4291")
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var statsGridView: some View {
        GlassEffectContainer(spacing: LGSpacing.md) {
            HStack(spacing: 0) {
                LGStatLabel(value: "+$5,800", label: "Income").frame(maxWidth: .infinity)
                Divider().frame(height: 40)
                LGStatLabel(value: "-$980", label: "Spent").frame(maxWidth: .infinity)
                Divider().frame(height: 40)
                LGStatLabel(value: "12", label: "Transactions").frame(maxWidth: .infinity)
            }
            .padding(.vertical, LGSpacing.md)
        }
    }

    var recentTransactionsView: some View {
        VStack(spacing: 0) {
            LGTransactionRow(title: "Salary", subtitle: "May 1", amount: "+$3,200.00", isDebit: false, icon: "building.2.fill")
            Divider()
            LGTransactionRow(title: "Coffee Shop", subtitle: "Today", amount: "-$4.50", isDebit: true, icon: "cup.and.saucer.fill")
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var actionsView: some View {
        LGToolbarGroup {
            LGIconButton("arrow.up", label: "lg.banking.send.action") {}
            LGIconButton("arrow.down", label: "lg.banking.receive.action") {}
            LGIconButton("qrcode", label: "Scan") {}
            LGIconButton("doc.text", label: "Statement") {}
        }
    }

    var screenTitle: LocalizedStringKey { "Checking Account" }
    var accountNumber: String { "**** 4291" }
}

#Preview("Account Detail") {
    LGAccountDetailView(content: AccountDetailPreviewContent())
}

#Preview("Account Detail — Reduce Transparency") {
    LGAccountDetailView(content: AccountDetailPreviewContent())
        .lgPreviewReduceTransparency()
}
