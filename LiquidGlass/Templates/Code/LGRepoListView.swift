// LGRepoListView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGRepoListContent

/// Content slot protocol for ``LGRepoListView``.
public protocol LGRepoListContent {
    associatedtype ProfileHeaderView: View
    associatedtype RepoItemsView: View
    associatedtype PinnedView: View

    @ViewBuilder var profileHeaderView: ProfileHeaderView { get }
    @ViewBuilder var repoItemsView: RepoItemsView { get }
    @ViewBuilder var pinnedView: PinnedView { get }

    var screenTitle: LocalizedStringKey { get }
    var repoCount: Int { get }
}

// MARK: - LGRepoListView

/// A code repository list template: profile header, pinned repos, and full repo list.
public struct LGRepoListView<Content: LGRepoListContent>: View {

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
                    content.profileHeaderView
                        .padding(.horizontal, LGSpacing.md)

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Pinned")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        content.pinnedView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        HStack {
                            Text("Repositories")
                                .font(theme.typography.headline)
                                .foregroundStyle(theme.colors.onSurface)
                            Spacer()
                            LGBadge(.count(content.repoCount))
                        }
                        .padding(.horizontal, LGSpacing.md)

                        content.repoItemsView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .searchable(text: .constant(""), prompt: Text("lg.search.placeholder", bundle: .lg))
        }
    }
}

// MARK: - Preview

private struct CodePreviewContent: LGRepoListContent {
    var profileHeaderView: some View {
        LGCard(.info) {
            HStack(spacing: LGSpacing.md) {
                LGAvatar(initials: "JG", size: .large)
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    Text("jesusgutierrezlopez")
                        .font(.headline)
                    Text("iOS Developer · Apple Platforms")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    var repoItemsView: some View {
        VStack(spacing: LGSpacing.sm) {
            GlassEffectContainer(spacing: LGSpacing.sm) {
                VStack(spacing: LGSpacing.sm) {
                    LGCard(.compact) {
                        VStack(alignment: .leading, spacing: LGSpacing.xs) {
                            Text("LiquidGlass").font(.headline)
                            Text("Private Swift framework for Liquid Glass UI").font(.caption).foregroundStyle(.secondary)
                            HStack(spacing: LGSpacing.sm) {
                                LGTag("Swift", style: .surface)
                                LGTag("Private", style: .destructive)
                            }
                        }
                    }
                }
            }
        }
    }

    var pinnedView: some View {
        LGCard(.compact) {
            Text("No pinned repos yet.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var screenTitle: LocalizedStringKey { "Code" }
    var repoCount: Int { 42 }
}

#Preview("Repo List") {
    LGRepoListView(content: CodePreviewContent())
}

#Preview("Repo List — Reduce Transparency") {
    LGRepoListView(content: CodePreviewContent())
        .lgPreviewReduceTransparency()
}
