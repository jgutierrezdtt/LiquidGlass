// LGClaimFormView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGClaimFormContent

/// Content slot protocol for ``LGClaimFormView``.
public protocol LGClaimFormContent {
    associatedtype IncidentFormView: View
    associatedtype AttachmentsView: View
    associatedtype SummaryView: View

    @ViewBuilder var incidentFormView: IncidentFormView { get }
    @ViewBuilder var attachmentsView: AttachmentsView { get }
    @ViewBuilder var summaryView: SummaryView { get }

    var screenTitle: LocalizedStringKey { get }
    var currentStep: Int { get }
    var totalSteps: Int { get }
    var canSubmit: Bool { get }
    var onSubmit: () -> Void { get }
}

// MARK: - LGClaimFormView

/// An insurance claim filing template: multi-step form with incident, attachments, and summary.
public struct LGClaimFormView<Content: LGClaimFormContent>: View {

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
                // Step progress
                VStack(spacing: LGSpacing.sm) {
                    HStack {
                        Text("Step \(content.currentStep) of \(content.totalSteps)")
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.secondary)
                        Spacer()
                    }
                    LGProgressBar(
                        value: Double(content.currentStep) / Double(content.totalSteps),
                        label: "lg.progress.label"
                    )
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.vertical, LGSpacing.sm)

                ScrollView {
                    VStack(spacing: LGSpacing.lg) {
                        GlassEffectContainer(spacing: LGSpacing.md) {
                            VStack(spacing: LGSpacing.md) {
                                switch content.currentStep {
                                case 2: content.attachmentsView
                                case 3: content.summaryView
                                default: content.incidentFormView
                                }
                            }
                            .padding(LGSpacing.md)
                        }
                        .padding(.horizontal, LGSpacing.md)
                    }
                    .padding(.top, LGSpacing.md)
                    .padding(.bottom, LGSpacing.xxl)
                }

                // Submit button on final step
                if content.currentStep == content.totalSteps {
                    LGButton("Submit Claim", style: content.canSubmit ? .glassProminent : .glass, action: content.onSubmit)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, LGSpacing.lg)
                        .padding(.bottom, LGSpacing.md)
                        .disabled(!content.canSubmit)
                        .accessibilityHint(Text("Submits your claim for review"))
                }
            }
            .navigationTitle(content.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

private struct ClaimFormPreviewContent: LGClaimFormContent {
    var incidentFormView: some View {
        VStack(spacing: LGSpacing.md) {
            LGTextField("Incident description", text: .constant(""))
            LGTextField("Incident date", text: .constant(""), systemImage: "calendar")
            LGTextField("Location", text: .constant(""), systemImage: "mappin")
        }
    }

    var attachmentsView: some View {
        VStack(spacing: LGSpacing.md) {
            LGCard(.compact) {
                HStack {
                    Image(systemName: "camera.fill").accessibilityHidden(true)
                    Text("Add Photos / Documents")
                }
            }
        }
    }

    var summaryView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.sm) {
            Text("Review your claim before submitting.").font(.body).foregroundStyle(.secondary)
            LGTag("Auto Insurance · Collision", style: .surface)
        }
    }

    var screenTitle: LocalizedStringKey { "File a Claim" }
    var currentStep: Int { 1 }
    var totalSteps: Int { 3 }
    var canSubmit: Bool { false }
    var onSubmit: () -> Void { {} }
}

#Preview("Claim Form") {
    LGClaimFormView(content: ClaimFormPreviewContent())
}

#Preview("Claim Form — Reduce Transparency") {
    LGClaimFormView(content: ClaimFormPreviewContent())
        .lgPreviewReduceTransparency()
}
