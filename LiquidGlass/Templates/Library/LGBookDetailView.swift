// LGBookDetailView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBookDetailContent

/// Content slot protocol for ``LGBookDetailView``.
public protocol LGBookDetailContent {
    associatedtype CoverView: View
    associatedtype MetadataView: View
    associatedtype SynopsisView: View
    associatedtype ReviewsPreviewView: View

    @ViewBuilder var coverView: CoverView { get }
    @ViewBuilder var metadataView: MetadataView { get }
    @ViewBuilder var synopsisView: SynopsisView { get }
    @ViewBuilder var reviewsPreviewView: ReviewsPreviewView { get }

    var bookTitle: LocalizedStringKey { get }
    var author: String { get }
    var onRead: () -> Void { get }
    var onAddToLibrary: () -> Void { get }
    var isInLibrary: Bool { get }
}

// MARK: - LGBookDetailView

/// A digital library book detail template: cover, metadata, synopsis, reviews, and CTA actions.
public struct LGBookDetailView<Content: LGBookDetailContent>: View {

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
                    // Hero cover + title
                    VStack(spacing: LGSpacing.md) {
                        content.coverView
                            .frame(width: 140, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: CGFloat.lgRadius(.md)))
                            .shadow(radius: 12)

                        VStack(spacing: LGSpacing.xs) {
                            Text(content.bookTitle)
                                .font(theme.typography.title)
                                .multilineTextAlignment(.center)
                            Text(content.author)
                                .font(theme.typography.body)
                                .foregroundStyle(theme.colors.secondary)
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Metadata
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        content.metadataView
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // CTAs
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        HStack(spacing: LGSpacing.sm) {
                            LGButton("Read", systemImage: "book.fill", style: .glassProminent, action: content.onRead)
                                .frame(maxWidth: .infinity)
                                .accessibilityHint(Text("Opens the book reader"))
                            LGButton(
                                content.isInLibrary ? "In Library" : "Add to Library",
                                systemImage: content.isInLibrary ? "checkmark" : "plus",
                                style: .glass,
                                action: content.onAddToLibrary
                            )
                            .frame(maxWidth: .infinity)
                            .accessibilityHint(Text(content.isInLibrary ? "Already in your library" : "Adds this book to your library"))
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Synopsis
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Synopsis")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                        content.synopsisView
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Reviews
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Reviews")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.reviewsPreviewView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
                .padding(.bottom, LGSpacing.xxl)
            }
            .navigationTitle(content.bookTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

private struct BookDetailPreviewContent: LGBookDetailContent {
    var coverView: some View {
        LinearGradient(colors: [.brown, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Image(systemName: "book.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white.opacity(0.6))
                    .accessibilityHidden(true)
            }
    }

    var metadataView: some View {
        HStack(spacing: LGSpacing.xl) {
            LGStatLabel(value: "342", label: "Pages")
            LGStatLabel(value: "4.8", label: "Rating")
            LGStatLabel(value: "Sci-Fi", label: "Genre")
        }
    }

    var synopsisView: some View {
        Text("A brilliant scientist discovers a way to fold space-time, opening travel to distant galaxies—but at a cost no one anticipated.")
            .font(.body)
            .foregroundStyle(.secondary)
    }

    var reviewsPreviewView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    HStack {
                        Text("J. García").font(.headline)
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill").font(.caption2).foregroundStyle(.yellow).accessibilityHidden(true)
                            }
                        }
                    }
                    Text("One of the best sci-fi novels I've read in years.").font(.body)
                }
            }
        }
    }

    var bookTitle: LocalizedStringKey { "Fold of Space" }
    var author: String { "M. Nakamura" }
    var onRead: () -> Void { {} }
    var onAddToLibrary: () -> Void { {} }
    var isInLibrary: Bool { false }
}

#Preview("Book Detail") {
    LGBookDetailView(content: BookDetailPreviewContent())
}

#Preview("Book Detail — Reduce Transparency") {
    LGBookDetailView(content: BookDetailPreviewContent())
        .lgPreviewReduceTransparency()
}
