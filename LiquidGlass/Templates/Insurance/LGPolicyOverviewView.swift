// LGPolicyOverviewView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGPolicyOverviewContent

/// Content slot protocol for ``LGPolicyOverviewView``.
public protocol LGPolicyOverviewContent {
    associatedtype PolicyCardView: View
    associatedtype CoverageListView: View
    associatedtype ActionsView: View

    @ViewBuilder var policyCardView: PolicyCardView { get }
    @ViewBuilder var coverageListView: CoverageListView { get }
    @ViewBuilder var actionsView: ActionsView { get }

    var screenTitle: LocalizedStringKey { get }
    var policyStatus: LocalizedStringKey { get }
}

// MARK: - LGPolicyOverviewView

/// An insurance policy overview template: policy card, coverage list, and quick actions.
public struct LGPolicyOverviewView<Content: LGPolicyOverviewContent>: View {

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
                            content.policyCardView
                            content.actionsView
                        }
                    }

                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Coverage Details")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.horizontal, LGSpacing.md)

                        content.coverageListView
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct InsurancePreviewContent: LGPolicyOverviewContent {
    var policyCardView: some View {
        LGCard(.hero) {
            VStack(alignment: .leading, spacing: LGSpacing.sm) {
                HStack {
                    LGTag("Active", systemImage: "checkmark.circle.fill", style: .accent)
                    Spacer()
                    Text("Policy #INS-2024-007")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                LGStatLabel(value: "$250,000", label: "Coverage Limit")
            }
        }
    }

    var coverageListView: some View {
        VStack(spacing: 0) {
            LGCard(.compact) {
                HStack {
                    Image(systemName: "house.fill").foregroundStyle(.blue).accessibilityHidden(true)
                    Text("Home & Property")
                    Spacer()
                    Text("$150,000").foregroundStyle(.secondary).font(.caption)
                }
            }
            LGCard(.compact) {
                HStack {
                    Image(systemName: "car.fill").foregroundStyle(.green).accessibilityHidden(true)
                    Text("Auto")
                    Spacer()
                    Text("$50,000").foregroundStyle(.secondary).font(.caption)
                }
            }
        }
    }

    var actionsView: some View {
        LGToolbarGroup {
            LGIconButton("doc.fill", label: "File Claim") {}
            LGIconButton("pencil", label: "Edit Policy") {}
            LGIconButton("square.and.arrow.up", label: "Share") {}
        }
    }

    var screenTitle: LocalizedStringKey { "My Policy" }
    var policyStatus: LocalizedStringKey { "Active" }
}

#Preview("Policy Overview") {
    LGPolicyOverviewView(content: InsurancePreviewContent())
}

#Preview("Policy Overview — Reduce Transparency") {
    LGPolicyOverviewView(content: InsurancePreviewContent())
        .lgPreviewReduceTransparency()
}
