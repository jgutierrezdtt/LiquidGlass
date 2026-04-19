// LGTransactionListView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTransactionListContent

/// Content slot protocol for ``LGTransactionListView``.
public protocol LGTransactionListContent {
    associatedtype FilterBarView: View
    associatedtype TransactionsView: View
    associatedtype SummaryView: View

    @ViewBuilder var filterBarView: FilterBarView { get }
    @ViewBuilder var transactionsView: TransactionsView { get }
    @ViewBuilder var summaryView: SummaryView { get }

    var screenTitle: LocalizedStringKey { get }
    var totalCount: Int { get }
}

// MARK: - LGTransactionListView

/// A full transaction list template with filter bar and period summary.
public struct LGTransactionListView<Content: LGTransactionListContent>: View {

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
                    content.summaryView
                        .padding(.horizontal, LGSpacing.md)

                    ScrollView(.horizontal, showsIndicators: false) {
                        content.filterBarView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    content.transactionsView
                        .padding(.horizontal, LGSpacing.md)
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .searchable(text: .constant(""), prompt: Text("lg.search.placeholder", bundle: .lg))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LGIconButton("arrow.down.doc", label: "Export") {}
                }
            }
        }
    }
}

// MARK: - Preview

private struct TxListPreviewContent: LGTransactionListContent {
    var filterBarView: some View {
        HStack(spacing: LGSpacing.sm) {
            LGTag("All", style: .accent)
            LGTag("Income", style: .surface)
            LGTag("Expenses", style: .surface)
            LGTag("Transfers", style: .surface)
        }
    }

    var transactionsView: some View {
        GlassEffectContainer(spacing: 0) {
            VStack(spacing: 0) {
                LGTransactionRow(title: "Salary", subtitle: "May 1", amount: "+$3,200.00", isDebit: false, icon: "building.2.fill")
                Divider()
                LGTransactionRow(title: "Rent", subtitle: "May 2", amount: "-$1,200.00", isDebit: true, icon: "house.fill")
                Divider()
                LGTransactionRow(title: "Coffee Shop", subtitle: "May 3", amount: "-$4.50", isDebit: true, icon: "cup.and.saucer.fill")
            }
        }
    }

    var summaryView: some View {
        GlassEffectContainer(spacing: LGSpacing.md) {
            HStack(spacing: LGSpacing.xl) {
                LGStatLabel(value: "+$3,200", label: "Income", trend: .up("+8%"))
                LGStatLabel(value: "-$1,890", label: "Expenses", trend: .down("-3%"))
            }
            .padding(.horizontal, LGSpacing.md)
            .padding(.vertical, LGSpacing.sm)
        }
    }

    var screenTitle: LocalizedStringKey { "lg.banking.transactions.title" }
    var totalCount: Int { 42 }
}

#Preview("Transaction List") {
    LGTransactionListView(content: TxListPreviewContent())
}

#Preview("Transaction List — Reduce Transparency") {
    LGTransactionListView(content: TxListPreviewContent())
        .lgPreviewReduceTransparency()
}
