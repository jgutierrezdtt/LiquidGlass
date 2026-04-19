// LGButton.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Button Style

/// The visual style of an ``LGButton``.
public enum LGButtonStyle {
    /// Standard glass button — maps to `ButtonStyle.glass`.
    case glass
    /// Prominent glass button — maps to `ButtonStyle.glassProminent`.
    case glassProminent
    /// Glass button tinted with a custom color.
    case glassTinted(Color)
    /// Glass button using the theme's destructive color.
    case glassDestructive
}

// MARK: - LGButton

/// A Liquid Glass button atom.
///
/// Wraps SwiftUI's native glass button styles and extends them with semantic style variants.
/// Use multiple ``LGButton``s inside a `GlassEffectContainer` for optimal glass morphing.
///
/// ```swift
/// GlassEffectContainer(spacing: 12) {
///     HStack(spacing: 12) {
///         LGButton("Send", style: .glassProminent) { }
///         LGButton("Cancel", style: .glass) { }
///     }
/// }
/// ```
public struct LGButton: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let label: LocalizedStringKey
    private let systemImage: String?
    private let style: LGButtonStyle
    private let action: () -> Void

    // MARK: Init

    /// Creates an ``LGButton`` with a text label.
    /// - Parameters:
    ///   - label: The localized label text.
    ///   - style: The glass visual style. Defaults to `.glass`.
    ///   - action: The closure to execute when tapped.
    public init(
        _ label: LocalizedStringKey,
        style: LGButtonStyle = .glass,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = nil
        self.style = style
        self.action = action
    }

    /// Creates an ``LGButton`` with a text label and a leading SF Symbol.
    /// - Parameters:
    ///   - label: The localized label text.
    ///   - systemImage: The SF Symbol name for the leading icon.
    ///   - style: The glass visual style. Defaults to `.glass`.
    ///   - action: The closure to execute when tapped.
    public init(
        _ label: LocalizedStringKey,
        systemImage: String,
        style: LGButtonStyle = .glass,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.style = style
        self.action = action
    }

    // MARK: Body

    public var body: some View {
        resolvedButton
            .accessibilityLabel(Text(label))
            .accessibilityHint(Text("lg.accessibility.button.hint", bundle: .lg))
    }

    // MARK: Private

    @ViewBuilder
    private var resolvedButton: some View {
        switch style {
        case .glass:
            Button(action: action) { buttonContent }
                .buttonStyle(.glass)
        case .glassProminent:
            Button(action: action) { buttonContent }
                .buttonStyle(.glassProminent)
        case .glassTinted(let color):
            Button(action: action) { buttonContent }
                .buttonStyle(.glass(.regular.tint(color)))
        case .glassDestructive:
            Button(action: action) { buttonContent }
                .buttonStyle(.glass(.regular.tint(theme.colors.destructive)))
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        if let icon = systemImage {
            Label {
                Text(label)
                    .font(theme.typography.body)
            } icon: {
                Image(systemName: icon)
                    .accessibilityHidden(true)
            }
        } else {
            Text(label)
                .font(theme.typography.body)
        }
    }
}

// MARK: - Preview

#Preview("Glass Styles") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                LGButton("Continue", style: .glassProminent) {}
                LGButton("Cancel", style: .glass) {}
                LGButton("Delete", style: .glassDestructive) {}
                LGButton("Pay", systemImage: "creditcard.fill", style: .glassProminent) {}
            }
        }
        .padding()
    }
}
