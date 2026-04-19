// LGProductDetailView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGProductDetailContent

/// Content slot protocol for ``LGProductDetailView``.
public protocol LGProductDetailContent {
    associatedtype MediaGalleryView: View
    associatedtype ProductInfoView: View
    associatedtype ReviewsView: View
    associatedtype RelatedProductsView: View

    @ViewBuilder var mediaGalleryView: MediaGalleryView { get }
    @ViewBuilder var productInfoView: ProductInfoView { get }
    @ViewBuilder var reviewsView: ReviewsView { get }
    @ViewBuilder var relatedProductsView: RelatedProductsView { get }

    var productName: LocalizedStringKey { get }
    var priceLabel: String { get }
    var onAddToCart: () -> Void { get }
    var onBuyNow: () -> Void { get }
}

// MARK: - LGProductDetailView

/// A shopping product detail template: media gallery, info, reviews, and related products.
public struct LGProductDetailView<Content: LGProductDetailContent>: View {

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
                    // Media gallery
                    content.mediaGalleryView
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .clipped()

                    // Product info
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        content.productInfoView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // CTAs
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        HStack(spacing: LGSpacing.sm) {
                            LGButton("lg.shopping.add.to.cart", style: .glass, action: content.onAddToCart)
                                .frame(maxWidth: .infinity)
                                .accessibilityHint(Text("Adds this item to your shopping cart"))
                            LGButton("Buy Now", style: .glassProminent, action: content.onBuyNow)
                                .frame(maxWidth: .infinity)
                                .accessibilityHint(Text("Proceeds directly to checkout with this item"))
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Reviews
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Reviews")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.reviewsView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // Related
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("You May Also Like")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.relatedProductsView
                    }
                }
                .padding(.bottom, LGSpacing.xxl)
            }
            .navigationTitle(content.productName)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .top)
        }
    }
}

// MARK: - Preview

private struct ProductDetailPreviewContent: LGProductDetailContent {
    var mediaGalleryView: some View {
        LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Image(systemName: "shoeprints.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.4))
                    .accessibilityHidden(true)
            }
    }

    var productInfoView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.sm) {
            HStack {
                Text(priceLabel)
                    .font(.title.bold())
                Spacer()
                HStack(spacing: LGSpacing.xs) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow).accessibilityHidden(true)
                    Text("4.8 (234)").font(.caption).foregroundStyle(.secondary)
                }
            }
            Text("Premium running shoe crafted with breathable mesh and responsive foam midsole.")
                .font(.body)
                .foregroundStyle(.secondary)
            HStack(spacing: LGSpacing.sm) {
                LGTag("Running", style: .surface)
                LGTag("Unisex", style: .surface)
                LGTag("Eco", systemImage: "leaf.fill", style: .custom(.green, foreground: .white))
            }
        }
    }

    var reviewsView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    HStack {
                        LGAvatar(initials: "JG", size: .small)
                        Text("JG").font(.headline)
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill").font(.caption2).foregroundStyle(.yellow).accessibilityHidden(true)
                            }
                        }
                    }
                    Text("Best running shoes I've owned. Very comfortable.").font(.body)
                }
            }
        }
    }

    var relatedProductsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LGSpacing.md) {
                ForEach(["Trail Shoe", "Road Shoe"], id: \.self) { name in
                    LGCard(.compact) {
                        VStack(alignment: .leading, spacing: LGSpacing.xs) {
                            Text(name).font(.headline)
                            Text("$89.99").font(.body.bold())
                        }
                        .frame(width: 140)
                    }
                }
            }
            .padding(.horizontal, LGSpacing.md)
        }
    }

    var productName: LocalizedStringKey { "Pro Runner X" }
    var priceLabel: String { "$129.99" }
    var onAddToCart: () -> Void { {} }
    var onBuyNow: () -> Void { {} }
}

#Preview("Product Detail") {
    LGProductDetailView(content: ProductDetailPreviewContent())
}

#Preview("Product Detail — Reduce Transparency") {
    LGProductDetailView(content: ProductDetailPreviewContent())
        .lgPreviewReduceTransparency()
}
