// LGIconButton.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGIconButton

/// A circular icon-only Liquid Glass button atom.
///
/// Use for toolbar actions, floating controls, and compact interactive elements.
/// Supports glass morphing via `@Namespace` when placed inside a `GlassEffectContainer`.
///
/// ```swift
/// @Namespace private var ns
///
/// GlassEffectContainer(spacing: 8) {
///     HStack(spacing: 8) {
///         LGIconButton("arrow.up", label: "Send", namespace: ns, morphID: "send") {}
///         LGIconButton("arrow.down", label: "Receive", namespace: ns, morphID: "receive") {}
///     }
/// }
/// ```
public struct LGIconButton: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.isFocused) private var isFocused   // tvOS focus support

    private let systemName: String
    private let accessibilityLabel: LocalizedStringKey
    private let accessibilityHint: LocalizedStringKey?
    private let size: LGIconButtonSize
    private let tint: Color?
    private let namespace: Namespace.ID?
    private let morphID: AnyHashable?
    private let action: () -> Void

    // MARK: Init

    /// Creates an ``LGIconButton``.
    /// - Parameters:
    ///   - systemName: The SF Symbol name.
    ///   - label: Accessibility label (required).
    ///   - hint: Accessibility hint (optional).
    ///   - size: Button size tier. Defaults to `.medium`.
    ///   - tint: Optional tint color for the glass effect.
    ///   - namespace: Optional `@Namespace` for morph transitions.
    ///   - morphID: Unique ID within the namespace for morphing.
    ///   - action: Closure executed on tap.
    public init(
        _ systemName: String,
        label: LocalizedStringKey,
        hint: LocalizedStringKey? = nil,
        size: LGIconButtonSize = .medium,
        tint: Color? = nil,
        namespace: Namespace.ID? = nil,
        morphID: AnyHashable? = nil,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityLabel = label
        self.accessibilityHint = hint
        self.size = size
        self.tint = tint
        self.namespace = namespace
        self.morphID = morphID
        self.action = action
    }

    // MARK: Body

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size.iconSize, weight: .semibold))
                .frame(width: size.frameSize, height: size.frameSize)
                .accessibilityLabel(Text(accessibilityLabel))
        }
        .glassEffect(resolvedGlass.interactive())
        .optionalGlassEffectID(morphID, namespace: namespace)
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityHint(accessibilityHintValue)
    }

    // MARK: Private

    private var resolvedGlass: Glass {
        if let tint {
            return .regular.tint(tint)
        }
        return .regular
    }

    private var accessibilityHintValue: Text {
        if let hint = accessibilityHint {
            return Text(hint)
        } else {
            return Text("lg.accessibility.button.hint", bundle: .lg)
        }
    }
}

// MARK: - Size

/// Named size tiers for ``LGIconButton``.
public enum LGIconButtonSize {
    /// 32 pt frame, 14 pt icon — compact toolbar contexts.
    case small
    /// 44 pt frame, 18 pt icon — standard toolbar and floating controls.
    case medium
    /// 56 pt frame, 22 pt icon — prominent hero actions.
    case large

    var frameSize: CGFloat {
        switch self { case .small: 32; case .medium: 44; case .large: 56 }
    }

    var iconSize: CGFloat {
        switch self { case .small: 14; case .medium: 18; case .large: 22 }
    }
}

// MARK: - Optional glassEffectID helper

private extension View {
    @ViewBuilder
    func optionalGlassEffectID(_ id: AnyHashable?, namespace: Namespace.ID?) -> some View {
        if let id, let namespace {
            self.glassEffectID(id, in: namespace)
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview("Icon Buttons") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                LGIconButton("arrow.up", label: "Send") {}
                LGIconButton("arrow.down", label: "Receive") {}
                LGIconButton("qrcode", label: "Scan") {}
                LGIconButton("ellipsis", label: "More") {}
            }
        }
        .padding()
    }
}
