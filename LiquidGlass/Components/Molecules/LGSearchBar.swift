// LGSearchBar.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGSearchBar

/// An inline search bar molecule with a Liquid Glass background.
///
/// Supports expand/collapse animation using `GlassEffectTransition.matchedGeometry`
/// when placed inside a `GlassEffectContainer` with a `@Namespace`.
///
/// ```swift
/// @Namespace private var ns
/// @State private var query = ""
///
/// GlassEffectContainer(spacing: 0) {
///     LGSearchBar(text: $query, namespace: ns)
/// }
/// ```
public struct LGSearchBar: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @Binding private var text: String
    @FocusState private var isFocused: Bool

    private let namespace: Namespace.ID?
    private let onSubmit: (() -> Void)?

    // MARK: Init

    /// Creates an ``LGSearchBar``.
    /// - Parameters:
    ///   - text: Binding to the search query string.
    ///   - namespace: Optional `@Namespace` for matched-geometry glass transition.
    ///   - onSubmit: Optional closure called when the user submits the search.
    public init(
        text: Binding<String>,
        namespace: Namespace.ID? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.namespace = namespace
        self.onSubmit = onSubmit
    }

    // MARK: Body

    public var body: some View {
        HStack(spacing: LGSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? theme.colors.primary : theme.colors.secondary)
                .font(theme.typography.body)
                .animation(LGAnimations.snappy, value: isFocused)
                .accessibilityHidden(true)

            TextField("lg.search.placeholder", text: $text)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }
                .accessibilityLabel(Text("lg.search.placeholder", bundle: .lg))

            if !text.isEmpty {
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
        .background(searchBackground)
        .animation(LGAnimations.snappy, value: text.isEmpty)
    }

    // MARK: Private

    @ViewBuilder
    private var searchBackground: some View {
        if reduceTransparency {
            Capsule().fill(theme.colors.surface.opacity(0.9))
        } else if let ns = namespace {
            Capsule().fill(.clear)
                .glassEffect()
                .glassEffectID("searchbar", in: ns)
        } else {
            Capsule().fill(.clear)
                .glassEffect()
        }
    }
}

// MARK: - Preview

private struct LGSearchBarPreview: View {
    @State private var query = ""
    @Namespace private var ns

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            LGSearchBar(text: $query, namespace: ns)
                .padding(.horizontal, LGSpacing.md)
        }
    }
}

#Preview("Search Bar") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        LGSearchBarPreview()
            .padding()
    }
}
