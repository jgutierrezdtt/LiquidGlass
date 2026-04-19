// LGSettingsView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGSettingsContent

/// Content slot protocol for ``LGSettingsView``.
public protocol LGSettingsContent {
    associatedtype ProfileView: View
    associatedtype SettingsSectionsView: View
    associatedtype FooterView: View

    @ViewBuilder var profileView: ProfileView { get }
    @ViewBuilder var settingsSectionsView: SettingsSectionsView { get }
    @ViewBuilder var footerView: FooterView { get }

    var screenTitle: LocalizedStringKey { get }
}

// MARK: - LGSettingsView

/// A settings template: profile header, grouped settings sections, and footer.
public struct LGSettingsView<Content: LGSettingsContent>: View {

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
            List {
                Section {
                    content.profileView
                        .listRowBackground(listRowBackground)
                }

                content.settingsSectionsView

                Section {
                    content.footerView
                        .listRowBackground(listRowBackground)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle(content.screenTitle)
        }
    }

    @ViewBuilder
    private var listRowBackground: some View {
        if reduceTransparency {
            Color(uiColor: .secondarySystemBackground)
        } else {
            Color.clear
                .glassEffect(in: .rect(cornerRadius: .lgRadius(.md)))
        }
    }
}

// MARK: - Preview

private struct SettingsPreviewContent: LGSettingsContent {
    var profileView: some View {
        HStack(spacing: LGSpacing.md) {
            LGAvatar(initials: "JG", size: .large)
            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text("Jesús Gutiérrez").font(.headline)
                Text("jesús@example.com").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            LGIconButton("chevron.right", label: "View Profile") {}
        }
    }

    var settingsSectionsView: some View {
        Group {
            Section("Appearance") {
                Label("Theme", systemImage: "paintbrush").foregroundStyle(.primary)
                Label("Display", systemImage: "sun.max").foregroundStyle(.primary)
            }
            Section("Privacy") {
                Label("Notifications", systemImage: "bell").foregroundStyle(.primary)
                Label("Security", systemImage: "lock.shield").foregroundStyle(.primary)
            }
        }
    }

    var footerView: some View {
        LGButton("Sign Out", style: .glassDestructive) {}
            .frame(maxWidth: .infinity)
    }

    var screenTitle: LocalizedStringKey { "lg.settings.title" }
}

#Preview("Settings") {
    LGSettingsView(content: SettingsPreviewContent())
}

#Preview("Settings — Reduce Transparency") {
    LGSettingsView(content: SettingsPreviewContent())
        .lgPreviewReduceTransparency()
}
