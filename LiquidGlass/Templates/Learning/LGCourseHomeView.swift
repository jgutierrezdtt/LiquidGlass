// LGCourseHomeView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGCourseHomeContent

/// Content slot protocol for ``LGCourseHomeView``.
public protocol LGCourseHomeContent {
    associatedtype FeaturedView: View
    associatedtype LessonListView: View
    associatedtype ProgressSummaryView: View

    /// Featured course or banner at the top of the home.
    @ViewBuilder var featuredView: FeaturedView { get }
    /// Scrollable list of lessons or modules.
    @ViewBuilder var lessonListView: LessonListView { get }
    /// Compact progress summary (e.g., overall completion ring).
    @ViewBuilder var progressSummaryView: ProgressSummaryView { get }

    var screenTitle: LocalizedStringKey { get }
}

// MARK: - LGCourseHomeView

/// A learning course home template: featured banner, progress summary, and lesson list.
public struct LGCourseHomeView<Content: LGCourseHomeContent>: View {

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
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            content.featuredView
                            content.progressSummaryView
                        }
                    }

                    content.lessonListView
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct CoursePreviewContent: LGCourseHomeContent {
    var featuredView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                LGTag("New", systemImage: "sparkles", style: .accent)
                Text("SwiftUI Mastery")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
            }
        }
    }

    var lessonListView: some View {
        VStack(spacing: 0) {
            LGLessonRow(title: "Introduction to SwiftUI", duration: "10 min", isCompleted: true)
            Divider()
            LGLessonRow(title: "View Modifiers Deep Dive", duration: "18 min", progress: 0.6)
            Divider()
            LGLessonRow(title: "Animations and Transitions", duration: "22 min", progress: 0)
        }
    }

    var progressSummaryView: some View {
        HStack(spacing: LGSpacing.lg) {
            LGProgressRing(value: 0.45, size: 64, label: "lg.progress.label")
            LGStatLabel(value: "3/7", label: "Lessons completed")
        }
        .padding(.horizontal, LGSpacing.md)
        .padding(.vertical, LGSpacing.sm)
    }

    var screenTitle: LocalizedStringKey { "My Courses" }
}

#Preview("Course Home") {
    LGCourseHomeView(content: CoursePreviewContent())
}

#Preview("Course Home — Reduce Transparency") {
    LGCourseHomeView(content: CoursePreviewContent())
        .lgPreviewReduceTransparency()
}
