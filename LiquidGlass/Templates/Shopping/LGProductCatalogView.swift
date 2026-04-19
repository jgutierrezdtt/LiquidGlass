// LGProductCatalogView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGProductCatalogContent

/// Content slot protocol for ``LGProductCatalogView``.
public protocol LGProductCatalogContent {
    associatedtype FiltersView: View
    associatedtype ProductGridView: View
    associatedtype CartPreviewView: View

    @ViewBuilder var filtersView: FiltersView { get }
    @ViewBuilder var productGridView: ProductGridView { get }
    @ViewBuilder var cartPreviewView: CartPreviewView { get }

    var screenTitle: LocalizedStringKey { get }
    var cartItemCount: Int { get }
}

// MARK: - LGProductCatalogView

/// A shopping catalog template: filter strip, product grid, and floating cart preview.
public struct LGProductCatalogView<Content: LGProductCatalogContent>: View {

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

                    content.productGridView
                        .padding(.horizontal, LGSpacing.md)
                }
                .padding(.top, LGSpacing.md)
            }
            .safeAreaInset(edge: .bottom) {
                if content.cartItemCount > 0 {
                    content.cartPreviewView
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.bottom, LGSpacing.sm)
                        .transition(.opacity)
                }
            }
            .animation(LGAnimations.snappy, value: content.cartItemCount)
            .navigationTitle(content.screenTitle)
            .searchable(text: .constant(""), prompt: Text("lg.search.placeholder", bundle: .lg))
        }
    }
}

// MARK: - Preview

private struct ShoppingPreviewContent: LGProductCatalogContent {
    var filtersView: some View {
        HStack(spacing: LGSpacing.sm) {
            LGTag("All", style: .accent)
            LGTag("Electronics", style: .surface)
            LGTag("Clothing", style: .surface)
            LGTag("Books", style: .surface)
        }
    }

    var productGridView: some View {
        VStack(spacing: 0) {
            LGProductRow(title: "iPhone 17 Pro", subtitle: "Space Black, 256 GB", price: "$1,099") {}
            Divider()
            LGProductRow(title: "AirPods Pro 3", subtitle: "White", price: "$249") {}
        }
    }

    var cartPreviewView: some View {
        LGCard(.compact) {
            HStack {
                Image(systemName: "cart.fill").accessibilityHidden(true)
                Text("Cart")
                    .font(.headline)
                Spacer()
                LGBadge(.count(cartItemCount))
                LGButton("Checkout", style: .glassProminent) {}
            }
        }
    }

    var screenTitle: LocalizedStringKey { "Shop" }
    var cartItemCount: Int { 3 }
}

#Preview("Product Catalog") {
    LGProductCatalogView(content: ShoppingPreviewContent())
}

#Preview("Product Catalog — Reduce Transparency") {
    LGProductCatalogView(content: ShoppingPreviewContent())
        .lgPreviewReduceTransparency()
}
