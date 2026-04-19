// LGSplitLayout.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGSplitLayoutContent

/// Content slot protocol for ``LGSplitLayout``.
public protocol LGSplitLayoutContent {
    associatedtype SidebarView: View
    associatedtype DetailView: View

    /// The sidebar list/navigation content.
    @ViewBuilder var sidebar: SidebarView { get }
    /// The detail panel content.
    @ViewBuilder var detail: DetailView { get }
    /// Sidebar column width. Defaults to `.doubleProportionalDetail`.
    var columnVisibility: NavigationSplitViewVisibility { get }
}

public extension LGSplitLayoutContent {
    var columnVisibility: NavigationSplitViewVisibility { .automatic }
}

// MARK: - LGSplitLayout

/// A two-column split layout organism using `NavigationSplitView` with `backgroundExtensionEffect`.
///
/// ```swift
/// struct MyContent: LGSplitLayoutContent {
///     var sidebar: some View { SidebarList() }
///     var detail: some View { DetailPanel() }
/// }
///
/// LGSplitLayout(content: MyContent())
/// ```
public struct LGSplitLayout<Content: LGSplitLayoutContent>: View {

    @Environment(\.lgTheme) private var theme

    private let content: Content

    /// Creates an ``LGSplitLayout``.
    public init(content: Content) {
        self.content = content
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: .constant(content.columnVisibility)) {
            content.sidebar
        } detail: {
            content.detail
                .backgroundExtensionEffect()
        }
    }
}

// MARK: - Preview

private struct SplitPreviewContent: LGSplitLayoutContent {
    var sidebar: some View {
        List {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        .navigationTitle("Sidebar")
    }

    var detail: some View {
        VStack {
            Text("Select an item")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Detail")
    }
}

#Preview("Split Layout") {
    LGSplitLayout(content: SplitPreviewContent())
}
