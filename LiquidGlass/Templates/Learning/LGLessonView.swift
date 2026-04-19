// LGLessonView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGLessonViewContent

/// Content slot protocol for ``LGLessonView``.
public protocol LGLessonViewContent {
    associatedtype MediaView: View
    associatedtype ContentBodyView: View
    associatedtype NavigationControlsView: View

    @ViewBuilder var mediaView: MediaView { get }
    @ViewBuilder var contentBodyView: ContentBodyView { get }
    @ViewBuilder var navigationControlsView: NavigationControlsView { get }

    var lessonTitle: LocalizedStringKey { get }
    var lessonNumber: Int { get }
    var totalLessons: Int { get }
    var progress: Double { get }
}

// MARK: - LGLessonView

/// A lesson player template: media area, content body, progress bar, and prev/next controls.
public struct LGLessonView<Content: LGLessonViewContent>: View {

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
                // Media player area
                content.mediaView
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipped()

                // Progress
                VStack(spacing: LGSpacing.xs) {
                    LGProgressBar(value: content.progress, label: "lg.progress.label")
                    Text("Lesson \(content.lessonNumber) of \(content.totalLessons)")
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.vertical, LGSpacing.sm)

                // Body scroll
                ScrollView {
                    content.contentBodyView
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.bottom, LGSpacing.xxl)
                }

                // Navigation controls
                content.navigationControlsView
                    .padding(.horizontal, LGSpacing.md)
                    .padding(.bottom, LGSpacing.md)
            }
            .navigationTitle(content.lessonTitle)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .top)
        }
    }
}

// MARK: - Preview

private struct LessonPreviewContent: LGLessonViewContent {
    var mediaView: some View {
        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.9))
                    .accessibilityLabel(Text("Play lesson video"))
            }
    }

    var contentBodyView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.md) {
            Text("In this lesson you will learn about Swift concurrency, including async/await, actors, and structured concurrency.")
                .font(.body)
        }
    }

    var navigationControlsView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            HStack(spacing: LGSpacing.sm) {
                LGButton("Previous", style: .glass) {}
                    .frame(maxWidth: .infinity)
                LGButton("Next Lesson", style: .glassProminent) {}
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var lessonTitle: LocalizedStringKey { "Swift Concurrency" }
    var lessonNumber: Int { 3 }
    var totalLessons: Int { 12 }
    var progress: Double { 0.58 }
}

#Preview("Lesson") {
    LGLessonView(content: LessonPreviewContent())
}

#Preview("Lesson — Reduce Transparency") {
    LGLessonView(content: LessonPreviewContent())
        .lgPreviewReduceTransparency()
}
