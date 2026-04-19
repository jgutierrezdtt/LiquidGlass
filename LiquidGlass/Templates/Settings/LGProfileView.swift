// LGProfileView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGProfileContent

/// Content slot protocol for ``LGProfileView``.
public protocol LGProfileContent {
    associatedtype StatsView: View
    associatedtype ActivityView: View
    associatedtype ActionsView: View

    @ViewBuilder var statsView: StatsView { get }
    @ViewBuilder var activityView: ActivityView { get }
    @ViewBuilder var actionsView: ActionsView { get }

    var displayName: String { get }
    var username: String { get }
    var avatarInitials: String { get }
    var bio: LocalizedStringKey { get }
    var onEdit: () -> Void { get }
}

// MARK: - LGProfileView

/// A user profile template: avatar, bio, stats, activity feed, and quick actions.
public struct LGProfileView<Content: LGProfileContent>: View {

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
                    // Avatar + identity
                    VStack(spacing: LGSpacing.md) {
                        LGAvatar(initials: content.avatarInitials, size: .hero)
                            .accessibilityLabel(Text("Profile picture for \(content.displayName)"))

                        VStack(spacing: LGSpacing.xs) {
                            Text(content.displayName)
                                .font(theme.typography.title)
                                .foregroundStyle(theme.colors.onSurface)
                            Text("@\(content.username)")
                                .font(theme.typography.body)
                                .foregroundStyle(theme.colors.secondary)
                            Text(content.bio)
                                .font(theme.typography.body)
                                .foregroundStyle(theme.colors.secondary)
                                .multilineTextAlignment(.center)
                        }

                        LGButton("Edit Profile", systemImage: "pencil", style: .glass, action: content.onEdit)
                            .accessibilityHint(Text("Opens profile editing screen"))
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Stats
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        content.statsView
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Quick actions
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Quick Actions")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.actionsView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // Activity
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Recent Activity")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.activityView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.lg)
                .padding(.bottom, LGSpacing.xxl)
            }
            .navigationTitle("lg.settings.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LGIconButton("gearshape", label: "Settings") {}
                        .accessibilityHint(Text("Opens app settings"))
                }
            }
        }
    }
}

// MARK: - Preview

private struct ProfilePreviewContent: LGProfileContent {
    var statsView: some View {
        HStack(spacing: LGSpacing.xl) {
            LGStatLabel(value: "142", label: "Posts")
            LGStatLabel(value: "1.2K", label: "Followers")
            LGStatLabel(value: "381", label: "Following")
        }
    }

    var actionsView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            VStack(spacing: LGSpacing.sm) {
                HStack(spacing: LGSpacing.sm) {
                    LGIconButton("bookmark", label: "Saved items") {}
                        .accessibilityHint(Text("Shows your saved items"))
                    Text("Saved Items").font(.body).frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right").foregroundStyle(.secondary).accessibilityHidden(true)
                }
                Divider()
                HStack(spacing: LGSpacing.sm) {
                    LGIconButton("heart", label: "Liked content") {}
                        .accessibilityHint(Text("Shows content you liked"))
                    Text("Liked").font(.body).frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right").foregroundStyle(.secondary).accessibilityHidden(true)
                }
            }
            .padding(LGSpacing.sm)
        }
    }

    var activityView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCard(.compact) {
                HStack {
                    Image(systemName: "heart.fill").foregroundStyle(.pink).accessibilityHidden(true)
                    Text("Liked **Swift Concurrency Guide**").font(.body)
                    Spacer()
                    Text("2h").font(.caption).foregroundStyle(.secondary)
                }
            }
            LGCard(.compact) {
                HStack {
                    Image(systemName: "bookmark.fill").foregroundStyle(.yellow).accessibilityHidden(true)
                    Text("Saved **WWDC 2026 Recap**").font(.body)
                    Spacer()
                    Text("5h").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }

    var displayName: String { "Jesús Gutiérrez" }
    var username: String { "jgl" }
    var avatarInitials: String { "JG" }
    var bio: LocalizedStringKey { "Building apps for Apple platforms ✦ Open-source contributor" }
    var onEdit: () -> Void { {} }
}

#Preview("Profile") {
    LGProfileView(content: ProfilePreviewContent())
}

#Preview("Profile — Reduce Transparency") {
    LGProfileView(content: ProfilePreviewContent())
        .lgPreviewReduceTransparency()
}
