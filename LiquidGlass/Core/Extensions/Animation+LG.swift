// Animation+LG.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGAnimations

/// Named animation presets for LiquidGlass components.
///
/// Use these instead of `.easeIn`, `.easeOut`, or `.linear` for all Liquid Glass transitions
/// and state changes. Spring animations produce the fluid, physical feel that Liquid Glass design requires.
public enum LGAnimations {

    // MARK: Springs

    /// Bouncy spring — best for elements that appear from off-screen or expand from a tap.
    ///
    /// Response: 0.5s, dampingFraction: 0.7
    public static let bounce: Animation = .spring(response: 0.5, dampingFraction: 0.7)

    /// Snappy spring — best for quick state changes, toggles, and morphing transitions.
    ///
    /// Response: 0.3s, dampingFraction: 0.85
    public static let snappy: Animation = .spring(response: 0.3, dampingFraction: 0.85)

    /// Smooth spring — best for layout changes, size animations, and gentle re-arrangements.
    ///
    /// Response: 0.6s, dampingFraction: 1.0 (critically damped, no overshoot)
    public static let smooth: Animation = .spring(response: 0.6, dampingFraction: 1.0)

    /// Eased spring — best for opacity fades and subtle entrance/exit transitions.
    ///
    /// Response: 0.45s, dampingFraction: 0.9
    public static let ease: Animation = .spring(response: 0.45, dampingFraction: 0.9)

    // MARK: Durations

    /// Fast — 0.2 seconds. Use for instant feedback (button press, badge appear).
    public static let fast: Double = 0.2

    /// Medium — 0.35 seconds. Use for navigation transitions and state changes.
    public static let medium: Double = 0.35

    /// Slow — 0.5 seconds. Use for complex multi-step transitions and hero animations.
    public static let slow: Double = 0.5
}

// MARK: - Helpers

public extension View {
    /// Wraps a state change in a `withAnimation(LGAnimations.snappy)` closure.
    ///
    /// Convenience for the most common animation pattern in LiquidGlass components.
    /// Has no effect — use `withAnimation(LGAnimations.snappy) { ... }` directly in actions.
    ///
    /// - Note: This modifier is intentionally left as a namespace anchor for documentation.
    ///   Actual usage: `withAnimation(LGAnimations.snappy) { state.toggle() }`
    func lgAnimated() -> some View { self }
}
