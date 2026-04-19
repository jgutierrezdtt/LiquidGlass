// LGBookCatalogView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBookCatalogContent

/// Content slot protocol for ``LGBookCatalogView``.
public protocol LGBookCatalogContent {
    associatedtype FeaturedView: View
    associatedtype BookListView: View
    associatedtype CategoriesView: View

    @ViewBuilder var featuredView: FeaturedView { get }
    @ViewBuilder var bookListView: BookListView { get }
    @ViewBuilder var categoriesView: CategoriesView { get }

    var screenTitle: LocalizedStringKey { get }
}

// MARK: - LGBookCatalogView

/// A library book catalog template: featured picks, categories, and book list.
public struct LGBookCatalogView<Content: LGBookCatalogContent>: View {

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
                    content.featuredView
                        .padding(.horizontal, LGSpacing.md)

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Categories")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        ScrollView(.horizontal, showsIndicators: false) {
                            content.categoriesView
                                .padding(.horizontal, LGSpacing.md)
                        }
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("All Books")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        content.bookListView
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

private struct LibraryPreviewContent: LGBookCatalogContent {
    var featuredView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                LGTag("Staff Pick", systemImage: "star.fill", style: .accent)
                Text("The Swift Programming Language")
                    .font(.title2.bold())
                Text("Apple Inc.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var bookListView: some View {
        VStack(spacing: 0) {
            LGProductRow(title: "Swift in Depth", subtitle: "Tjeerd in 't Veen", price: "Free") {}
            Divider()
            LGProductRow(title: "SwiftUI Animations", subtitle: "Mark Moeykens", price: "$29.99") {}
        }
    }

    var categoriesView: some View {
        HStack(spacing: LGSpacing.sm) {
            LGTag("Programming", style: .accent)
            LGTag("Design", style: .surface)
            LGTag("Business", style: .surface)
            LGTag("Science", style: .surface)
        }
    }

    var screenTitle: LocalizedStringKey { "Library" }
}

#Preview("Book Catalog") {
    LGBookCatalogView(content: LibraryPreviewContent())
}

#Preview("Book Catalog — Reduce Transparency") {
    LGBookCatalogView(content: LibraryPreviewContent())
        .lgPreviewReduceTransparency()
}
