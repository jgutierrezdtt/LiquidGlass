// LGProgressDashboardView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGProgressDashboardContent

/// Content slot protocol for ``LGProgressDashboardView``.
public protocol LGProgressDashboardContent {
    associatedtype OverallRingView: View
    associatedtype CourseListView: View
    associatedtype StreakView: View
    associatedtype AchievementsPreviewView: View

    @ViewBuilder var overallRingView: OverallRingView { get }
    @ViewBuilder var courseListView: CourseListView { get }
    @ViewBuilder var streakView: StreakView { get }
    @ViewBuilder var achievementsPreviewView: AchievementsPreviewView { get }

    var screenTitle: LocalizedStringKey { get }
    var streakDays: Int { get }
}

// MARK: - LGProgressDashboardView

/// A learning progress dashboard template: overall ring, streak, course list, and achievements.
public struct LGProgressDashboardView<Content: LGProgressDashboardContent>: View {

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
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        HStack(spacing: LGSpacing.xl) {
                            content.overallRingView
                            content.streakView
                        }
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.vertical, LGSpacing.md)
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Courses")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.courseListView
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Recent Achievements")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.achievementsPreviewView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct ProgressDashPreviewContent: LGProgressDashboardContent {
    var overallRingView: some View {
        VStack(spacing: LGSpacing.xs) {
            LGProgressRing(value: 0.63, size: 88, label: "lg.progress.label")
            Text("Overall").font(.caption).foregroundStyle(.secondary)
        }
    }

    var courseListView: some View {
        VStack(spacing: 0) {
            LGLessonRow(title: "SwiftUI Mastery", duration: "6/12 lessons", progress: 0.5)
            Divider()
            LGLessonRow(title: "Swift Concurrency", duration: "12/12 lessons", isCompleted: true)
        }
        .padding(.horizontal, LGSpacing.md)
    }

    var streakView: some View {
        LGStatLabel(value: "\(streakDays)", label: "Day streak 🔥")
    }

    var achievementsPreviewView: some View {
        HStack(spacing: LGSpacing.md) {
            LGCard(.compact) {
                VStack(spacing: LGSpacing.xs) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow).accessibilityHidden(true)
                    Text("First Lesson").font(.caption)
                }
            }
            LGCard(.compact) {
                VStack(spacing: LGSpacing.xs) {
                    Image(systemName: "flame.fill").foregroundStyle(.orange).accessibilityHidden(true)
                    Text("7-Day Streak").font(.caption)
                }
            }
        }
    }

    var screenTitle: LocalizedStringKey { "My Progress" }
    var streakDays: Int { 14 }
}

#Preview("Progress Dashboard") {
    LGProgressDashboardView(content: ProgressDashPreviewContent())
}

#Preview("Progress Dashboard — Reduce Transparency") {
    LGProgressDashboardView(content: ProgressDashPreviewContent())
        .lgPreviewReduceTransparency()
}
