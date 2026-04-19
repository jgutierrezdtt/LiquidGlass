// LGTransferView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTransferContent

/// Content slot protocol for ``LGTransferView``.
public protocol LGTransferContent {
    associatedtype RecipientSelectorView: View
    associatedtype AccountSelectorView: View

    @ViewBuilder var recipientSelectorView: RecipientSelectorView { get }
    @ViewBuilder var accountSelectorView: AccountSelectorView { get }

    var screenTitle: LocalizedStringKey { get }
    var availableBalance: String { get }
    var onTransfer: (_ amount: String, _ note: String) -> Void { get }
}

// MARK: - LGTransferView

/// A money transfer template: recipient selector, amount input, account picker, and confirm CTA.
public struct LGTransferView<Content: LGTransferContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @State private var amount = ""
    @State private var note = ""

    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LGSpacing.lg) {
                    // Recipient
                    VStack(alignment: .leading, spacing: LGSpacing.sm) {
                        Text("Recipient")
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                        content.recipientSelectorView
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Amount + account
                    GlassEffectContainer(spacing: LGSpacing.md) {
                        VStack(spacing: LGSpacing.md) {
                            // Amount display
                            VStack(spacing: LGSpacing.xs) {
                                Text("Amount")
                                    .font(theme.typography.caption)
                                    .foregroundStyle(theme.colors.secondary)
                                LGTextField("0.00", text: $amount, systemImage: "dollarsign")
                                Text("Available: \(content.availableBalance)")
                                    .font(theme.typography.caption)
                                    .foregroundStyle(theme.colors.secondary)
                            }

                            content.accountSelectorView

                            LGTextField("Add a note (optional)", text: $note, systemImage: "pencil")
                        }
                        .padding(.horizontal, LGSpacing.md)
                        .padding(.vertical, LGSpacing.md)
                    }

                    LGButton("lg.banking.send.action", style: .glassProminent) {
                        content.onTransfer(amount, note)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, LGSpacing.lg)
                }
                .padding(.top, LGSpacing.md)
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct TransferPreviewContent: LGTransferContent {
    var recipientSelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LGSpacing.md) {
                ForEach(["JG", "AB", "MK"], id: \.self) { initials in
                    VStack(spacing: LGSpacing.xs) {
                        LGAvatar(initials: initials, size: .medium)
                        Text(initials).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    var accountSelectorView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            HStack(spacing: LGSpacing.sm) {
                LGCard(.compact) { Text("Checking · *4291").font(.caption) }
                LGCard(.compact) { Text("Savings · *8820").font(.caption) }
            }
        }
    }

    var screenTitle: LocalizedStringKey { "Send Money" }
    var availableBalance: String { "$4,820.00" }
    var onTransfer: (String, String) -> Void { { _, _ in } }
}

#Preview("Transfer") {
    LGTransferView(content: TransferPreviewContent())
}

#Preview("Transfer — Reduce Transparency") {
    LGTransferView(content: TransferPreviewContent())
        .lgPreviewReduceTransparency()
}
