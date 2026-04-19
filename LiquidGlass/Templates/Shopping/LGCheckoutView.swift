// LGCheckoutView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGCheckoutContent

/// Content slot protocol for ``LGCheckoutView``.
public protocol LGCheckoutContent {
    associatedtype ShippingFormView: View
    associatedtype PaymentFormView: View
    associatedtype OrderReviewView: View

    @ViewBuilder var shippingFormView: ShippingFormView { get }
    @ViewBuilder var paymentFormView: PaymentFormView { get }
    @ViewBuilder var orderReviewView: OrderReviewView { get }

    var screenTitle: LocalizedStringKey { get }
    var currentStep: Int { get }
    var totalLabel: String { get }
    var canProceed: Bool { get }
    var onProceed: () -> Void { get }
    var proceedLabel: LocalizedStringKey { get }
}

// MARK: - LGCheckoutView

/// A multi-step checkout template: shipping → payment → review with step indicator.
public struct LGCheckoutView<Content: LGCheckoutContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content
    private let stepLabels: [LocalizedStringKey] = ["Shipping", "Payment", "Review"]

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Step indicator
                GlassEffectContainer(spacing: LGSpacing.sm) {
                    HStack(spacing: LGSpacing.xs) {
                        ForEach(Array(stepLabels.enumerated()), id: \.offset) { index, label in
                            HStack(spacing: LGSpacing.xs) {
                                Circle()
                                    .fill(index < content.currentStep ? theme.colors.accent : theme.colors.secondary.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .accessibilityHidden(true)
                                Text(label)
                                    .font(theme.typography.label)
                                    .foregroundStyle(index < content.currentStep ? theme.colors.onSurface : theme.colors.secondary)
                            }
                            if index < stepLabels.count - 1 {
                                Spacer()
                                Rectangle()
                                    .fill(theme.colors.secondary.opacity(0.3))
                                    .frame(height: 1)
                                    .accessibilityHidden(true)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, LGSpacing.md)
                    .padding(.vertical, LGSpacing.sm)
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.sm)

                ScrollView {
                    VStack(spacing: LGSpacing.lg) {
                        GlassEffectContainer(spacing: LGSpacing.md) {
                            VStack(spacing: LGSpacing.md) {
                                switch content.currentStep {
                                case 2: content.paymentFormView
                                case 3: content.orderReviewView
                                default: content.shippingFormView
                                }
                            }
                            .padding(LGSpacing.md)
                        }
                        .padding(.horizontal, LGSpacing.md)
                    }
                    .padding(.top, LGSpacing.md)
                    .padding(.bottom, LGSpacing.xxl)
                }

                // Sticky proceed CTA
                GlassEffectContainer(spacing: LGSpacing.sm) {
                    HStack(spacing: LGSpacing.md) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total").font(theme.typography.caption).foregroundStyle(theme.colors.secondary)
                            Text(content.totalLabel).font(theme.typography.headline)
                        }
                        Spacer()
                        LGButton(content.proceedLabel, style: content.canProceed ? .glassProminent : .glass, action: content.onProceed)
                            .disabled(!content.canProceed)
                            .accessibilityHint(Text("Proceeds to the next checkout step"))
                    }
                    .padding(LGSpacing.md)
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.bottom, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

private struct CheckoutPreviewContent: LGCheckoutContent {
    var shippingFormView: some View {
        VStack(spacing: LGSpacing.md) {
            LGTextField("Full name", text: .constant(""))
            LGTextField("Address", text: .constant(""))
            LGTextField("City", text: .constant(""))
            HStack(spacing: LGSpacing.sm) {
                LGTextField("ZIP", text: .constant(""))
                LGTextField("Country", text: .constant(""))
            }
        }
    }

    var paymentFormView: some View {
        VStack(spacing: LGSpacing.md) {
            LGTextField("Card number", text: .constant(""), systemImage: "creditcard")
            HStack(spacing: LGSpacing.sm) {
                LGTextField("MM/YY", text: .constant(""))
                LGTextField("CVV", text: .constant(""), isSecure: true)
            }
        }
    }

    var orderReviewView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.sm) {
            LGTag("Free Shipping · Standard", systemImage: "shippingbox.fill", style: .surface)
            Text("2 items · $154.98")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    var screenTitle: LocalizedStringKey { "Checkout" }
    var currentStep: Int { 1 }
    var totalLabel: String { "$154.98" }
    var canProceed: Bool { true }
    var onProceed: () -> Void { {} }
    var proceedLabel: LocalizedStringKey { "Continue to Payment" }
}

#Preview("Checkout") {
    LGCheckoutView(content: CheckoutPreviewContent())
}

#Preview("Checkout — Reduce Transparency") {
    LGCheckoutView(content: CheckoutPreviewContent())
        .lgPreviewReduceTransparency()
}
