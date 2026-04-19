// LGBankingDashboardView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBankingDashboardContent

/// Content slot protocol for ``LGBankingDashboardView``.
public protocol LGBankingDashboardContent {
    associatedtype AccountCardView: View
    associatedtype TransactionListView: View
    associatedtype QuickActionsView: View

    /// The main balance/account card displayed at the top.
    @ViewBuilder var accountCardView: AccountCardView { get }
    /// The list of recent transactions.
    @ViewBuilder var transactionListView: TransactionListView { get }
    /// Quick action buttons (Send, Receive, Scan, etc.).
    @ViewBuilder var quickActionsView: QuickActionsView { get }

    var screenTitle: LocalizedStringKey { get }
    var userName: LocalizedStringKey { get }
}

// MARK: - LGBankingDashboardView

/// A banking dashboard template: balance card, quick actions, and transaction list.
public struct LGBankingDashboardView<Content: LGBankingDashboardContent>: View {

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
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            content.accountCardView
                            content.quickActionsView
                        }
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("lg.banking.transactions.title", bundle: .lg)
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        content.transactionListView
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct BankingPreviewContent: LGBankingDashboardContent {
    var accountCardView: some View {
        LGCard(.hero) {
            LGStatLabel(value: "$4,820.00", label: "lg.banking.balance.label", trend: .up("+12.4%"))
        }
    }

    var transactionListView: some View {
        VStack(spacing: 0) {
            LGTransactionRow(title: "Coffee Shop", subtitle: "Today, 9:30 AM", amount: "-$4.50", isDebit: true, icon: "cup.and.saucer.fill")
            Divider()
            LGTransactionRow(title: "Salary", subtitle: "Yesterday", amount: "+$3,200.00", isDebit: false, icon: "building.2.fill")
        }
    }

    var quickActionsView: some View {
        LGToolbarGroup {
            LGIconButton("arrow.up", label: "lg.banking.send.action") {}
            LGIconButton("arrow.down", label: "lg.banking.receive.action") {}
            LGIconButton("qrcode", label: "Scan") {}
        }
    }

    var screenTitle: LocalizedStringKey { "Banking" }
    var userName: LocalizedStringKey { "Jesús" }
}

#Preview("Banking Dashboard") {
    LGBankingDashboardView(content: BankingPreviewContent())
}

#Preview("Banking Dashboard — Reduce Transparency") {
    LGBankingDashboardView(content: BankingPreviewContent())
        .lgPreviewReduceTransparency()
}
