// LGAchievementsView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGAchievementsContent

/// Content slot protocol for ``LGAchievementsView``.
public protocol LGAchievementsContent {
    associatedtype FeaturedAchievementView: View
    associatedtype AchievementGridView: View
    associatedtype ProgressSummaryView: View

    @ViewBuilder var featuredAchievementView: FeaturedAchievementView { get }
    @ViewBuilder var achievementGridView: AchievementGridView { get }
    @ViewBuilder var progressSummaryView: ProgressSummaryView { get }

    var screenTitle: LocalizedStringKey { get }
    var unlockedCount: Int { get }
    var totalCount: Int { get }
}

// MARK: - LGAchievementsView

/// A gaming achievements template: featured unlock, overall progress, and achievement grid.
public struct LGAchievementsView<Content: LGAchievementsContent>: View {

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
                        VStack(spacing: LGSpacing.md) {
                            content.featuredAchievementView
                            content.progressSummaryView
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        HStack {
                            Text("All Achievements")
                                .font(theme.typography.headline)
                                .foregroundStyle(theme.colors.onSurface)
                            Spacer()
                            Text("\(content.unlockedCount)/\(content.totalCount)")
                                .font(theme.typography.caption)
                                .foregroundStyle(theme.colors.secondary)
                        }
                        .padding(.horizontal, LGSpacing.md)

                        content.achievementGridView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - LGAchievementCell

/// A single achievement cell for use in the achievements grid.
public struct LGAchievementCell: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    public let icon: String
    public let name: LocalizedStringKey
    public let isUnlocked: Bool

    public init(icon: String, name: LocalizedStringKey, isUnlocked: Bool) {
        self.icon = icon
        self.name = name
        self.isUnlocked = isUnlocked
    }

    public var body: some View {
        VStack(spacing: LGSpacing.xs) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(isUnlocked ? theme.colors.accent : theme.colors.secondary.opacity(0.4))
                .frame(width: 48, height: 48)
                .lgGlassCard(.sm)
                .accessibilityHidden(true)

            Text(name)
                .font(theme.typography.label)
                .foregroundStyle(isUnlocked ? theme.colors.onSurface : theme.colors.secondary.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(name))
        .accessibilityValue(isUnlocked ? Text("Unlocked") : Text("Locked"))
    }
}

// MARK: - Preview

private struct AchievementsPreviewContent: LGAchievementsContent {
    var featuredAchievementView: some View {
        LGCard(.info) {
            HStack(spacing: LGSpacing.md) {
                Image(systemName: "trophy.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.yellow)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    LGTag("New Unlock!", systemImage: "sparkles", style: .accent)
                    Text("First Victory")
                        .font(.headline)
                    Text("Win your first match")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    var achievementGridView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: LGSpacing.md) {
            LGAchievementCell(icon: "trophy.fill", name: "First Victory", isUnlocked: true)
            LGAchievementCell(icon: "flame.fill", name: "7-Day Streak", isUnlocked: true)
            LGAchievementCell(icon: "star.fill", name: "Perfect Score", isUnlocked: false)
            LGAchievementCell(icon: "crown.fill", name: "Champion", isUnlocked: false)
        }
    }

    var progressSummaryView: some View {
        HStack(spacing: LGSpacing.md) {
            LGProgressRing(value: Double(unlockedCount) / Double(totalCount), size: 56, label: "lg.progress.label")
            LGStatLabel(value: "\(unlockedCount)/\(totalCount)", label: "Unlocked")
        }
        .padding(.horizontal, LGSpacing.md)
        .padding(.vertical, LGSpacing.sm)
    }

    var screenTitle: LocalizedStringKey { "Achievements" }
    var unlockedCount: Int { 2 }
    var totalCount: Int { 24 }
}

#Preview("Achievements") {
    LGAchievementsView(content: AchievementsPreviewContent())
}

#Preview("Achievements — Reduce Transparency") {
    LGAchievementsView(content: AchievementsPreviewContent())
        .lgPreviewReduceTransparency()
}
