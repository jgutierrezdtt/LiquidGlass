// LGToolbarGroup.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGToolbarGroup

/// A horizontal group of toolbar actions wrapped in a `GlassEffectContainer`.
///
/// Use this to present 2–5 related actions with shared glass morphing.
/// Internally wraps icons in `GlassEffectContainer` and supports `@Namespace` for morphing.
///
/// ```swift
/// LGToolbarGroup(namespace: ns) {
///     LGIconButton("arrow.up", label: "Send", namespace: ns, morphID: "send") {}
///     LGIconButton("arrow.down", label: "Receive", namespace: ns, morphID: "receive") {}
///     LGIconButton("qrcode", label: "Scan", namespace: ns, morphID: "scan") {}
/// }
/// ```
public struct LGToolbarGroup<Content: View>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let spacing: CGFloat
    private let content: Content

    // MARK: Init

    /// Creates an ``LGToolbarGroup``.
    /// - Parameters:
    ///   - spacing: Spacing between items. Defaults to `LGSpacing.sm`.
    ///   - content: `@ViewBuilder` toolbar items (typically ``LGIconButton`` instances).
    public init(
        spacing: CGFloat = LGSpacing.sm,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    // MARK: Body

    public var body: some View {
        GlassEffectContainer(spacing: spacing) {
            HStack(spacing: spacing) {
                content
            }
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Preview

#Preview("Toolbar Group") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        VStack(spacing: LGSpacing.xl) {
            LGToolbarGroup {
                LGIconButton("arrow.up", label: "Send") {}
                LGIconButton("arrow.down", label: "Receive") {}
                LGIconButton("qrcode", label: "Scan") {}
            }

            LGToolbarGroup(spacing: 12) {
                LGIconButton("heart.fill", label: "Like", tint: .red) {}
                LGIconButton("square.and.arrow.up", label: "Share") {}
                LGIconButton("bookmark", label: "Save") {}
                LGIconButton("ellipsis", label: "More") {}
            }
        }
    }
}
