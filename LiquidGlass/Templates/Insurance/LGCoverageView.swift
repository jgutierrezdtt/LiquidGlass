// LGCoverageView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGCoverageContent

/// Content slot protocol for ``LGCoverageView``.
public protocol LGCoverageContent {
    associatedtype CoverageRingView: View
    associatedtype CoverageItemsView: View
    associatedtype ExclusionsView: View

    @ViewBuilder var coverageRingView: CoverageRingView { get }
    @ViewBuilder var coverageItemsView: CoverageItemsView { get }
    @ViewBuilder var exclusionsView: ExclusionsView { get }

    var screenTitle: LocalizedStringKey { get }
    var policyNumber: String { get }
    var coveragePercent: Double { get }
}

// MARK: - LGCoverageView

/// An insurance coverage details template: ring summary, covered items, and exclusions.
public struct LGCoverageView<Content: LGCoverageContent>: View {

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
                    // Hero ring + policy number
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        HStack(spacing: LGSpacing.xl) {
                            LGProgressRing(
                                value: content.coveragePercent,
                                size: 88,
                                label: "lg.progress.label"
                            )
                            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                                content.coverageRingView
                                Text("Policy #\(content.policyNumber)")
                                    .font(theme.typography.caption)
                                    .foregroundStyle(theme.colors.secondary)
                            }
                        }
                        .padding(LGSpacing.md)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Covered items
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("What's Covered")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.coverageItemsView
                            .padding(.horizontal, LGSpacing.md)
                    }

                    // Exclusions
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Exclusions")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)
                        content.exclusionsView
                            .padding(.horizontal, LGSpacing.md)
                    }
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - LGCoverageItem

/// A single coverage row showing what is (or isn't) covered.
public struct LGCoverageItem: View {

    @Environment(\.lgTheme) private var theme

    public let icon: String
    public let title: LocalizedStringKey
    public let description: LocalizedStringKey
    public let isCovered: Bool

    public init(icon: String, title: LocalizedStringKey, description: LocalizedStringKey, isCovered: Bool = true) {
        self.icon = icon; self.title = title; self.description = description; self.isCovered = isCovered
    }

    public var body: some View {
        LGCard(.compact) {
            HStack(spacing: LGSpacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isCovered ? theme.colors.accent : theme.colors.destructive)
                    .frame(width: 32)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: LGSpacing.xs) {
                    Text(title).font(theme.typography.body)
                    Text(description).font(theme.typography.caption).foregroundStyle(theme.colors.secondary)
                }
                Spacer()
                Image(systemName: isCovered ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCovered ? .green : theme.colors.destructive)
                    .accessibilityLabel(Text(isCovered ? "Covered" : "Not covered"))
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

private struct CoveragePreviewContent: LGCoverageContent {
    var coverageRingView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.xs) {
            LGTag("Comprehensive", style: .accent)
            LGStatLabel(value: "95%", label: "Coverage score")
        }
    }

    var coverageItemsView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCoverageItem(icon: "car.fill", title: "Collision", description: "Damage from accidents", isCovered: true)
            LGCoverageItem(icon: "flame.fill", title: "Fire & Theft", description: "Fire damage or vehicle theft", isCovered: true)
            LGCoverageItem(icon: "bolt.fill", title: "Roadside Assistance", description: "24/7 emergency support", isCovered: true)
        }
    }

    var exclusionsView: some View {
        VStack(spacing: LGSpacing.sm) {
            LGCoverageItem(icon: "wrench.fill", title: "Mechanical Breakdown", description: "Wear & tear not covered", isCovered: false)
        }
    }

    var screenTitle: LocalizedStringKey { "My Coverage" }
    var policyNumber: String { "POL-2026-4892" }
    var coveragePercent: Double { 0.95 }
}

#Preview("Coverage") {
    LGCoverageView(content: CoveragePreviewContent())
}

#Preview("Coverage — Reduce Transparency") {
    LGCoverageView(content: CoveragePreviewContent())
        .lgPreviewReduceTransparency()
}
