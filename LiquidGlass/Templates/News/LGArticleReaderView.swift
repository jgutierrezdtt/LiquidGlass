// LGArticleReaderView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGArticleReaderContent

/// Content slot protocol for ``LGArticleReaderView``.
public protocol LGArticleReaderContent {
    associatedtype HeroImageView: View
    associatedtype ArticleBodyView: View
    associatedtype RelatedArticlesView: View

    @ViewBuilder var heroImageView: HeroImageView { get }
    @ViewBuilder var articleBodyView: ArticleBodyView { get }
    @ViewBuilder var relatedArticlesView: RelatedArticlesView { get }

    var articleTitle: LocalizedStringKey { get }
    var publication: String { get }
    var publishedDate: String { get }
    var readingTime: String { get }
    var onBookmark: () -> Void { get }
    var onShare: () -> Void { get }
    var isBookmarked: Bool { get }
}

// MARK: - LGArticleReaderView

/// A news article reader template: hero image, metadata bar, body text, and related articles.
public struct LGArticleReaderView<Content: LGArticleReaderContent>: View {

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
                VStack(alignment: .leading, spacing: LGSpacing.lg) {
                    // Hero image
                    content.heroImageView
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()

                    // Meta
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text(content.articleTitle)
                            .font(theme.typography.display)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        HStack(spacing: LGSpacing.sm) {
                            Text(content.publication).font(theme.typography.caption.weight(.semibold))
                            Text("·").foregroundStyle(.secondary)
                            Text(content.publishedDate).font(theme.typography.caption)
                            Text("·").foregroundStyle(.secondary)
                            HStack(spacing: 4) {
                                Image(systemName: "clock").accessibilityHidden(true)
                                Text(content.readingTime)
                            }
                            .font(theme.typography.caption)
                        }
                        .foregroundStyle(theme.colors.secondary)
                        .padding(.horizontal, LGSpacing.md)

                        // Action toolbar
                        GlassEffectContainer(spacing: LGSpacing.xs) {
                            HStack(spacing: LGSpacing.xs) {
                                LGIconButton(
                                    content.isBookmarked ? "bookmark.fill" : "bookmark",
                                    label: content.isBookmarked ? "Remove bookmark" : "Bookmark",
                                    action: content.onBookmark
                                )
                                .accessibilityHint(Text(content.isBookmarked ? "Removes article from saved" : "Saves article for later"))
                                LGIconButton("square.and.arrow.up", label: "Share article", action: content.onShare)
                                    .accessibilityHint(Text("Opens share sheet for this article"))
                            }
                        }
                        .padding(.horizontal, LGSpacing.md)
                    }

                    // Article body
                    content.articleBodyView
                        .padding(.horizontal, LGSpacing.lg)

                    // Related
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Related Articles")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.relatedArticlesView
                    }
                }
                .padding(.bottom, LGSpacing.xxl)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .top)
        }
    }
}

// MARK: - Preview

private struct ArticleReaderPreviewContent: LGArticleReaderContent {
    var heroImageView: some View {
        LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Text("AI")
                    .font(.system(size: 64, weight: .black))
                    .foregroundStyle(.white.opacity(0.2))
            }
    }

    var articleBodyView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.md) {
            Text("Apple's new Liquid Glass design language marks a fundamental shift in how spatial computing interfaces are conceived — blurring the line between digital and physical.")
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
            Text("The technology leverages real-time environment sampling to produce glass surfaces that respond dynamically to whatever lies beneath them.")
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
        }
    }

    var relatedArticlesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LGSpacing.md) {
                ForEach(["visionOS 3 Preview", "WWDC 2026 Highlights"], id: \.self) { title in
                    LGCard(.compact) {
                        Text(title)
                            .font(.headline)
                            .frame(width: 150, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, LGSpacing.md)
        }
    }

    var articleTitle: LocalizedStringKey { "Liquid Glass: Apple's Bold Design Reset" }
    var publication: String { "TechDaily" }
    var publishedDate: String { "Jun 9, 2026" }
    var readingTime: String { "4 min read" }
    var onBookmark: () -> Void { {} }
    var onShare: () -> Void { {} }
    var isBookmarked: Bool { false }
}

#Preview("Article Reader") {
    LGArticleReaderView(content: ArticleReaderPreviewContent())
}

#Preview("Article Reader — Reduce Transparency") {
    LGArticleReaderView(content: ArticleReaderPreviewContent())
        .lgPreviewReduceTransparency()
}
