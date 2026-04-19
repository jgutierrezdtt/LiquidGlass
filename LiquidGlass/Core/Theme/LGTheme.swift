// LGTheme.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - Protocol

/// The theme contract for the LiquidGlass framework.
///
/// Implement this protocol to create a custom brand theme and inject it with `.lgTheme(_:)`.
/// All colors and typography tokens must be semantic — never hardcode specific colors inside
/// components.
public protocol LGThemeProtocol {
    /// Semantic color tokens for the theme.
    var colors: LGColorTokens { get }
    /// Semantic typography tokens for the theme.
    var typography: LGTypographyTokens { get }
}

// MARK: - Environment Key

private struct LGThemeKey: EnvironmentKey {
    static let defaultValue: any LGThemeProtocol = LGDefaultTheme()
}

public extension EnvironmentValues {
    /// The current LiquidGlass theme injected into the view hierarchy.
    var lgTheme: any LGThemeProtocol {
        get { self[LGThemeKey.self] }
        set { self[LGThemeKey.self] = newValue }
    }
}

// MARK: - View Modifier

public extension View {
    /// Injects a custom `LGThemeProtocol` implementation into the view hierarchy.
    ///
    /// Call this once at the root of your app:
    /// ```swift
    /// WindowGroup {
    ///     ContentView()
    ///         .lgTheme(MyBrandTheme())
    /// }
    /// ```
    /// - Parameter theme: The theme to apply to all descendant views.
    func lgTheme(_ theme: any LGThemeProtocol) -> some View {
        environment(\.lgTheme, theme)
    }
}

// MARK: - Default Theme

/// The built-in fallback theme. Maps all tokens to SwiftUI semantic system colors
/// and standard Dynamic Type fonts, so the framework works out of the box.
public struct LGDefaultTheme: LGThemeProtocol {
    public init() {}

    public var colors: LGColorTokens {
        #if canImport(UIKit)
        let surface = Color(uiColor: .systemBackground)
        #else
        let surface = Color(nsColor: .windowBackgroundColor)
        #endif
        return LGColorTokens(
            primary: Color.accentColor,
            secondary: Color.secondary,
            surface: surface,
            accent: Color.yellow,
            destructive: Color.red,
            onPrimary: Color.white,
            onSurface: Color.primary
        )
    }

    public var typography: LGTypographyTokens {
        LGTypographyTokens(
            display: .largeTitle,
            headline: .headline,
            title: .title2,
            body: .body,
            caption: .caption,
            label: .footnote
        )
    }
}
