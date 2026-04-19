// LGReaderView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGReaderContent

/// Content slot protocol for ``LGReaderView``.
public protocol LGReaderContent {
    associatedtype ChapterContentView: View

    @ViewBuilder var chapterContentView: ChapterContentView { get }

    var bookTitle: LocalizedStringKey { get }
    var chapterTitle: LocalizedStringKey { get }
    var readingProgress: Double { get }
    var onPreviousChapter: () -> Void { get }
    var onNextChapter: () -> Void { get }
    var hasPreviousChapter: Bool { get }
    var hasNextChapter: Bool { get }
}

// MARK: - LGReaderView

/// A digital reader template: immersive chapter text with floating navigation and progress bar.
public struct LGReaderView<Content: LGReaderContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @State private var showControls = true
    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Reader body
                ScrollView {
                    VStack(alignment: .leading, spacing: LGSpacing.lg) {
                        Text(content.chapterTitle)
                            .font(theme.typography.title)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.lg)

                        content.chapterContentView
                            .padding(.horizontal, LGSpacing.lg)
                    }
                    .padding(.vertical, LGSpacing.lg)
                    .padding(.bottom, 80) // room for floating bar
                }
                .onTapGesture {
                    withAnimation(reduceMotion ? .default : LGAnimations.snappy) {
                        showControls.toggle()
                    }
                }

                // Floating bottom nav
                if showControls {
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        HStack(spacing: LGSpacing.md) {
                            LGIconButton("chevron.left", label: "Previous Chapter", action: content.onPreviousChapter)
                                .disabled(!content.hasPreviousChapter)
                                .accessibilityHint(Text("Navigates to the previous chapter"))

                            VStack(spacing: LGSpacing.xs) {
                                LGProgressBar(value: content.readingProgress, label: "lg.progress.label")
                                Text("\(Int(content.readingProgress * 100))% read")
                                    .font(theme.typography.label)
                                    .foregroundStyle(theme.colors.secondary)
                            }
                            .frame(maxWidth: .infinity)

                            LGIconButton("chevron.right", label: "Next Chapter", action: content.onNextChapter)
                                .disabled(!content.hasNextChapter)
                                .accessibilityHint(Text("Navigates to the next chapter"))
                        }
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.vertical, LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)
                    .padding(.bottom, LGSpacing.md)
                    .transition(reduceMotion ? .identity : LGTransitions.slideUp)
                }
            }
            .animation(reduceMotion ? .default : LGAnimations.snappy, value: showControls)
            .navigationTitle(content.bookTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LGIconButton("textformat.size", label: "Text size settings") {}
                        .accessibilityHint(Text("Adjusts font size and reading preferences"))
                }
            }
        }
    }
}

// MARK: - Preview

private struct ReaderPreviewContent: LGReaderContent {
    var chapterContentView: some View {
        Text("""
        The station hung in the quiet dark between stars, a silver needle suspended against a tapestry of cold light. Inside, Dr. Amara Osei stared at the readout with steady hands and an unsteady heart.

        The numbers didn't lie. They never did. Three hundred and forty-two days since departure. Eleven light-years traveled. And yet—somehow—the clock back on Earth had barely moved.

        She pressed her palm to the cold viewport glass and let the silence answer her questions.
        """)
        .font(theme.typography.body)
        .foregroundStyle(theme.colors.onSurface)
        .lineSpacing(6)
    }

    @Environment(\.lgTheme) private var theme

    var bookTitle: LocalizedStringKey { "Fold of Space" }
    var chapterTitle: LocalizedStringKey { "Chapter 3 — The Station" }
    var readingProgress: Double { 0.28 }
    var onPreviousChapter: () -> Void { {} }
    var onNextChapter: () -> Void { {} }
    var hasPreviousChapter: Bool { true }
    var hasNextChapter: Bool { true }
}

#Preview("Reader") {
    LGReaderView(content: ReaderPreviewContent())
}

#Preview("Reader — Reduce Transparency") {
    LGReaderView(content: ReaderPreviewContent())
        .lgPreviewReduceTransparency()
}
