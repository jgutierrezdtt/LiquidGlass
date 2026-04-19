// LGCartView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGCartContent

/// Content slot protocol for ``LGCartView``.
public protocol LGCartContent {
    associatedtype CartItemsView: View
    associatedtype OrderSummaryView: View

    @ViewBuilder var cartItemsView: CartItemsView { get }
    @ViewBuilder var orderSummaryView: OrderSummaryView { get }

    var screenTitle: LocalizedStringKey { get }
    var itemCount: Int { get }
    var totalLabel: String { get }
    var onCheckout: () -> Void { get }
    var canCheckout: Bool { get }
}

// MARK: - LGCartView

/// A shopping cart template: item list, order summary, and checkout CTA.
public struct LGCartView<Content: LGCartContent>: View {

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
                        if content.itemCount == 0 {
                            LGCard(.info) {
                                VStack(spacing: LGSpacing.md) {
                                    Image(systemName: "cart").font(.largeTitle).foregroundStyle(.secondary).accessibilityHidden(true)
                                    Text("lg.empty.state.title")
                                        .font(theme.typography.body)
                                        .foregroundStyle(theme.colors.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, LGSpacing.lg)
                            }
                            .padding(.horizontal, LGSpacing.md)
                        } else {
                            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                                Text("\(content.itemCount) items")
                                    .font(theme.typography.caption)
                                    .foregroundStyle(theme.colors.secondary)
                                    .padding(.horizontal, LGSpacing.md)
                                content.cartItemsView
                                    .padding(.horizontal, LGSpacing.md)
                            }

                            GlassEffectContainer(spacing: LGSpacing.sm) {
                                content.orderSummaryView
                                    .padding(LGSpacing.md)
                            }
                            .padding(.horizontal, LGSpacing.md)
                        }
                    }
                    .padding(.top, LGSpacing.md)
                    .padding(.bottom, LGSpacing.xxl)
                }

                // Sticky checkout CTA
                if content.canCheckout {
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        HStack(spacing: LGSpacing.md) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Total").font(theme.typography.caption).foregroundStyle(theme.colors.secondary)
                                Text(content.totalLabel).font(theme.typography.headline)
                            }
                            Spacer()
                            LGButton("Checkout", style: .glassProminent, action: content.onCheckout)
                                .accessibilityHint(Text("Proceeds to checkout with your cart items"))
                        }
                        .padding(LGSpacing.md)
                    }
                    .padding(.horizontal, LGSpacing.md)
                    .padding(.bottom, LGSpacing.md)
                }
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct CartPreviewContent: LGCartContent {
    var cartItemsView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGProductRow(
                title: "Pro Runner X",
                subtitle: "Size 42 · Black",
                price: "$129.99",
                onAddToCart: {}
            )
            LGProductRow(
                title: "Running Socks (3-pack)",
                subtitle: "Size L · White",
                price: "$24.99",
                onAddToCart: {}
            )
        }
    }

    var orderSummaryView: some View {
        VStack(spacing: LGSpacing.sm) {
            HStack {
                Text("Subtotal").foregroundStyle(.secondary)
                Spacer()
                Text("$154.98")
            }
            HStack {
                Text("Shipping").foregroundStyle(.secondary)
                Spacer()
                LGTag("Free", style: .custom(.green, foreground: .white))
            }
            Divider()
            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text("$154.98").font(.headline)
            }
        }
    }

    var screenTitle: LocalizedStringKey { "My Cart" }
    var itemCount: Int { 2 }
    var totalLabel: String { "$154.98" }
    var onCheckout: () -> Void { {} }
    var canCheckout: Bool { true }
}

#Preview("Cart") {
    LGCartView(content: CartPreviewContent())
}

#Preview("Cart — Reduce Transparency") {
    LGCartView(content: CartPreviewContent())
        .lgPreviewReduceTransparency()
}
