// LGTextField.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTextField

/// A text input field with a Liquid Glass card background.
///
/// Supports leading icons, secure entry, and trailing clear buttons.
/// The glass effect is applied to the field container, not individual characters.
///
/// ```swift
/// @State private var email = ""
///
/// LGTextField("Email address", text: $email, systemImage: "envelope")
/// LGTextField("Password", text: $password, isSecure: true)
/// ```
public struct LGTextField: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    @Binding private var text: String
    @FocusState private var isFocused: Bool

    private let placeholder: LocalizedStringKey
    private let systemImage: String?
    private let isSecure: Bool
    private let showClearButton: Bool

    // MARK: Init

    /// Creates an ``LGTextField``.
    /// - Parameters:
    ///   - placeholder: Localized placeholder text.
    ///   - text: Binding to the input string.
    ///   - systemImage: Optional SF Symbol name for the leading icon.
    ///   - isSecure: If `true`, renders as a secure entry field. Defaults to `false`.
    ///   - showClearButton: If `true`, shows a trailing clear button when non-empty. Defaults to `true`.
    public init(
        _ placeholder: LocalizedStringKey,
        text: Binding<String>,
        systemImage: String? = nil,
        isSecure: Bool = false,
        showClearButton: Bool = true
    ) {
        self.placeholder = placeholder
        self._text = text
        self.systemImage = systemImage
        self.isSecure = isSecure
        self.showClearButton = showClearButton
    }

    // MARK: Body

    public var body: some View {
        HStack(spacing: LGSpacing.sm) {
            if let icon = systemImage {
                Image(systemName: icon)
                    .foregroundStyle(isFocused ? theme.colors.primary : theme.colors.secondary)
                    .font(theme.typography.body)
                    .accessibilityHidden(true)
                    .animation(LGAnimations.snappy, value: isFocused)
            }

            inputField

            if showClearButton && !text.isEmpty {
                Button {
                    withAnimation(LGAnimations.snappy) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(theme.colors.secondary)
                        .accessibilityLabel(Text("lg.button.close", bundle: .lg))
                }
                .transition(LGTransitions.scaleIn)
            }
        }
        .padding(.horizontal, LGSpacing.md)
        .padding(.vertical, LGSpacing.sm + 2)
        .background(fieldBackground)
        .animation(LGAnimations.snappy, value: text.isEmpty)
    }

    // MARK: Private

    @ViewBuilder
    private var inputField: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
                .focused($isFocused)
        } else {
            TextField(placeholder, text: $text)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
                .focused($isFocused)
        }
    }

    @ViewBuilder
    private var fieldBackground: some View {
        if reduceTransparency {
            LGShape.rounded(.md)
                .fill(theme.colors.surface.opacity(0.9))
                .overlay(
                    LGShape.rounded(.md)
                        .strokeBorder(
                            isFocused ? theme.colors.primary : Color.clear,
                            lineWidth: 1.5
                        )
                )
        } else {
            LGShape.rounded(.md)
                .fill(.clear)
                .glassEffect(in: .rect(cornerRadius: .lgRadius(.md)))
                .overlay(
                    LGShape.rounded(.md)
                        .strokeBorder(
                            isFocused ? theme.colors.primary.opacity(0.6) : Color.clear,
                            lineWidth: 1.5
                        )
                )
        }
    }
}

// MARK: - Preview

private struct LGTextFieldPreview: View {
    @State private var email = ""
    @State private var password = ""
    @State private var search = ""

    var body: some View {
        VStack(spacing: LGSpacing.md) {
            LGTextField("Email address", text: $email, systemImage: "envelope")
            LGTextField("Password", text: $password, systemImage: "lock", isSecure: true)
            LGTextField("lg.search.placeholder", text: $search, systemImage: "magnifyingglass")
        }
        .padding()
    }
}

#Preview("Text Fields") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        LGTextFieldPreview()
    }
}
