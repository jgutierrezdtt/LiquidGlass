// LGNewsFeedView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGNewsFeedContent

/// Content slot protocol for ``LGNewsFeedView``.
public protocol LGNewsFeedContent {
    associatedtype HeroArticleView: View
    associatedtype ArticleListView: View
    associatedtype TopicsView: View

    @ViewBuilder var heroArticleView: HeroArticleView { get }
    @ViewBuilder var articleListView: ArticleListView { get }
    @ViewBuilder var topicsView: TopicsView { get }

    var screenTitle: LocalizedStringKey { get }
    var unreadCount: Int { get }
}

// MARK: - LGNewsFeedView

/// A news feed template: hero article, topic filters, and article list.
public struct LGNewsFeedView<Content: LGNewsFeedContent>: View {

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
                    content.heroArticleView
                        .padding(.horizontal, LGSpacing.md)

                    ScrollView(.horizontal, showsIndicators: false) {
                        content.topicsView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    content.articleListView
                        .padding(.horizontal, LGSpacing.md)
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LGIconButton("bell.fill", label: "Notifications") {}
                        .lgBadge(content.unreadCount)
                }
            }
        }
    }
}

// MARK: - Preview

private struct NewsPreviewContent: LGNewsFeedContent {
    var heroArticleView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                LGTag("Breaking", systemImage: "bolt.fill", style: .destructive)
                Text("Apple unveils iOS 26 with Liquid Glass design")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                Text("WWDC 2026 · 2 hours ago")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var articleListView: some View {
        VStack(spacing: 0) {
            LGCard(.compact) {
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    Text("SwiftUI 6 brings new glass effects").font(.body.weight(.medium))
                    Text("Yesterday at 3:00 PM").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }

    var topicsView: some View {
        HStack(spacing: LGSpacing.sm) {
            LGTag("Technology", style: .accent)
            LGTag("Design", style: .surface)
            LGTag("Business", style: .surface)
            LGTag("Science", style: .surface)
        }
    }

    var screenTitle: LocalizedStringKey { "News" }
    var unreadCount: Int { 5 }
}

#Preview("News Feed") {
    LGNewsFeedView(content: NewsPreviewContent())
}

#Preview("News Feed — Reduce Transparency") {
    LGNewsFeedView(content: NewsPreviewContent())
        .lgPreviewReduceTransparency()
}
