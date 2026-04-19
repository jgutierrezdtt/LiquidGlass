// LGShape.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Shape Size

/// Named size tiers for rounded rectangle shapes.
public enum LGShapeSize {
    /// 8 pt corner radius — small badges, tags, compact elements.
    case sm
    /// 12 pt corner radius — standard cards, text fields, panels.
    case md
    /// 20 pt corner radius — large cards, hero sections, modals.
    case lg
    /// 28 pt corner radius — very prominent cards, full-bleed panels.
    case xl

    var radius: CGFloat {
        switch self {
        case .sm: return 8
        case .md: return 12
        case .lg: return 20
        case .xl: return 28
        }
    }
}

// MARK: - Shape Tokens

/// Shape tokens used throughout the LiquidGlass framework.
///
/// These are framework-level constants — not configurable per theme — to enforce
/// concentric corner radius proportions across all components.
public enum LGShape {
    /// A capsule (infinite corner radius). Used for buttons, tags, and chips.
    public static let capsule = Capsule()

    /// A rounded rectangle with the given size tier.
    public static func rounded(_ size: LGShapeSize) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: size.radius, style: .continuous)
    }

    /// A `ConcentricRectangle` that nests proportionally inside its container.
    /// Use for elements inside rounded containers (e.g., a card inside a page).
    public static let concentric = ConcentricRectangle()
}

// MARK: - Convenience

public extension CGFloat {
    /// Returns the corner radius for the given LGShapeSize.
    static func lgRadius(_ size: LGShapeSize) -> CGFloat { size.radius }
}
