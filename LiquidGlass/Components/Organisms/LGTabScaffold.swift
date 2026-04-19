// LGTabScaffold.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGTabItem

/// A single tab declaration for ``LGTabScaffold``.
public struct LGTabItem<Content: View>: Identifiable {
    public let id: String
    public let title: LocalizedStringKey
    public let systemImage: String
    public let content: Content

    /// Creates an ``LGTabItem``.
    /// - Parameters:
    ///   - id: A stable unique string identifier.
    ///   - title: The localized tab label.
    ///   - systemImage: SF Symbol for the tab icon.
    ///   - content: `@ViewBuilder` tab body content.
    public init(
        id: String,
        title: LocalizedStringKey,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }
}

// MARK: - LGTabScaffold (2 tabs)

/// A tab-based scaffold organism wrapping SwiftUI's `TabView` with Liquid Glass styling.
///
/// Uses `.sidebarAdaptable` on iPadOS/macOS for side-bar navigation and
/// `.tabBarMinimizeBehavior(.onScrollDown)` for immersive scroll experiences.
///
/// Provide 2–5 ``LGTabItem`` values. Use the overloads matching your tab count.
///
/// ```swift
/// LGTabScaffold(
///     LGTabItem(id: "home", title: "Home", systemImage: "house") { HomeView() },
///     LGTabItem(id: "profile", title: "Profile", systemImage: "person") { ProfileView() }
/// )
/// ```
public struct LGTabScaffold2<C0: View, C1: View>: View {
    private let tab0: LGTabItem<C0>
    private let tab1: LGTabItem<C1>

    public init(_ tab0: LGTabItem<C0>, _ tab1: LGTabItem<C1>) {
        self.tab0 = tab0
        self.tab1 = tab1
    }

    public var body: some View {
        TabView {
            Tab(tab0.title, systemImage: tab0.systemImage) { tab0.content }
                .accessibilityLabel(Text(tab0.title))
            Tab(tab1.title, systemImage: tab1.systemImage) { tab1.content }
                .accessibilityLabel(Text(tab1.title))
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

// MARK: - LGTabScaffold (3 tabs)

public struct LGTabScaffold3<C0: View, C1: View, C2: View>: View {
    private let tab0: LGTabItem<C0>
    private let tab1: LGTabItem<C1>
    private let tab2: LGTabItem<C2>

    public init(_ tab0: LGTabItem<C0>, _ tab1: LGTabItem<C1>, _ tab2: LGTabItem<C2>) {
        self.tab0 = tab0; self.tab1 = tab1; self.tab2 = tab2
    }

    public var body: some View {
        TabView {
            Tab(tab0.title, systemImage: tab0.systemImage) { tab0.content }.accessibilityLabel(Text(tab0.title))
            Tab(tab1.title, systemImage: tab1.systemImage) { tab1.content }.accessibilityLabel(Text(tab1.title))
            Tab(tab2.title, systemImage: tab2.systemImage) { tab2.content }.accessibilityLabel(Text(tab2.title))
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

// MARK: - LGTabScaffold (4 tabs)

public struct LGTabScaffold4<C0: View, C1: View, C2: View, C3: View>: View {
    private let tab0: LGTabItem<C0>
    private let tab1: LGTabItem<C1>
    private let tab2: LGTabItem<C2>
    private let tab3: LGTabItem<C3>

    public init(
        _ tab0: LGTabItem<C0>, _ tab1: LGTabItem<C1>,
        _ tab2: LGTabItem<C2>, _ tab3: LGTabItem<C3>
    ) {
        self.tab0 = tab0; self.tab1 = tab1; self.tab2 = tab2; self.tab3 = tab3
    }

    public var body: some View {
        TabView {
            Tab(tab0.title, systemImage: tab0.systemImage) { tab0.content }.accessibilityLabel(Text(tab0.title))
            Tab(tab1.title, systemImage: tab1.systemImage) { tab1.content }.accessibilityLabel(Text(tab1.title))
            Tab(tab2.title, systemImage: tab2.systemImage) { tab2.content }.accessibilityLabel(Text(tab2.title))
            Tab(tab3.title, systemImage: tab3.systemImage) { tab3.content }.accessibilityLabel(Text(tab3.title))
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

// MARK: - LGTabScaffold (5 tabs)

public struct LGTabScaffold5<C0: View, C1: View, C2: View, C3: View, C4: View>: View {
    private let tab0: LGTabItem<C0>
    private let tab1: LGTabItem<C1>
    private let tab2: LGTabItem<C2>
    private let tab3: LGTabItem<C3>
    private let tab4: LGTabItem<C4>

    public init(
        _ tab0: LGTabItem<C0>, _ tab1: LGTabItem<C1>,
        _ tab2: LGTabItem<C2>, _ tab3: LGTabItem<C3>,
        _ tab4: LGTabItem<C4>
    ) {
        self.tab0 = tab0; self.tab1 = tab1; self.tab2 = tab2; self.tab3 = tab3; self.tab4 = tab4
    }

    public var body: some View {
        TabView {
            Tab(tab0.title, systemImage: tab0.systemImage) { tab0.content }.accessibilityLabel(Text(tab0.title))
            Tab(tab1.title, systemImage: tab1.systemImage) { tab1.content }.accessibilityLabel(Text(tab1.title))
            Tab(tab2.title, systemImage: tab2.systemImage) { tab2.content }.accessibilityLabel(Text(tab2.title))
            Tab(tab3.title, systemImage: tab3.systemImage) { tab3.content }.accessibilityLabel(Text(tab3.title))
            Tab(tab4.title, systemImage: tab4.systemImage) { tab4.content }.accessibilityLabel(Text(tab4.title))
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

// MARK: - Preview

#Preview("Tab Scaffold") {
    LGTabScaffold4(
        LGTabItem(id: "home", title: "Home", systemImage: "house") { Text("Home") },
        LGTabItem(id: "discover", title: "Discover", systemImage: "sparkles") { Text("Discover") },
        LGTabItem(id: "search", title: "Search", systemImage: "magnifyingglass") { Text("Search") },
        LGTabItem(id: "profile", title: "Profile", systemImage: "person.crop.circle") { Text("Profile") }
    )
}
