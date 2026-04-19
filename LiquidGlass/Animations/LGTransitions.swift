// LGTransitions.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTransitions

/// Named transition presets built on `GlassEffectTransition` for LiquidGlass components.
///
/// Rules (from ADR-008 and Apple guidelines):
/// - Use `.lgMatchedMorph` for views that appear/disappear within the container's assigned spacing.
/// - Use `.lgMaterialize` for views that are farther apart than the container's spacing.
/// - Use `.lgSlideUp` for toasts, banners, and bottom-anchored contextual elements.
public enum LGTransitions {

    /// Matched geometry morph — the system morphs the glass shape into/out of nearby shapes.
    ///
    /// Use for elements that appear within `GlassEffectContainer`'s assigned spacing.
    public static let matchedMorph = GlassEffectTransition.matchedGeometry

    /// Materialize — the glass shape fades/appears independently without morphing.
    ///
    /// Use for elements that are farther from other glass shapes than the container's spacing.
    public static let materialize = GlassEffectTransition.materialize

    /// Slide up with opacity — for toasts, bottom sheets, and anchored overlays.
    public static let slideUp: AnyTransition =
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )

    /// Slide from trailing edge — for navigation push-style transitions.
    public static let slideTrailing: AnyTransition =
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )

    /// Scale + opacity — for popovers and contextual menus.
    public static let scaleIn: AnyTransition =
        .scale(scale: 0.9).combined(with: .opacity)
}

// MARK: - LGMorphModifier

/// A view modifier that registers a view with a `GlassEffectContainer` morph namespace.
///
/// Use this to drive `glassEffectID` + `glassEffectUnion` together from a single modifier:
/// ```swift
/// LGButton("Action")
///     .lgMorph(id: "send-button", namespace: ns)
/// ```
public struct LGMorphModifier: ViewModifier {
    let id: AnyHashable
    let namespace: Namespace.ID

    public func body(content: Content) -> some View {
        content
            .glassEffectID(id, in: namespace)
    }
}

public extension View {
    /// Registers this view for glass morphing transitions.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this shape within the namespace.
    ///   - namespace: The `@Namespace` shared by all shapes in the same `GlassEffectContainer`.
    func lgMorph(id: some Hashable, namespace: Namespace.ID) -> some View {
        modifier(LGMorphModifier(id: id, namespace: namespace))
    }

    /// Registers this view to share a unified glass shape with other views bearing the same union ID.
    ///
    /// - Parameters:
    ///   - unionID: The shared identifier for the unified glass shape group.
    ///   - namespace: The `@Namespace` shared with other views in the same group.
    func lgGlassUnion(id: some Hashable, namespace: Namespace.ID) -> some View {
        glassEffectUnion(id: id, namespace: namespace)
    }
}
