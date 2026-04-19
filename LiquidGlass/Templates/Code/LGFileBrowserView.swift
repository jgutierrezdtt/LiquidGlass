// LGFileBrowserView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGFileBrowserContent

/// Content slot protocol for ``LGFileBrowserView``.
public protocol LGFileBrowserContent {
    associatedtype BreadcrumbView: View
    associatedtype FileListView: View
    associatedtype EmptyStateView: View

    @ViewBuilder var breadcrumbView: BreadcrumbView { get }
    @ViewBuilder var fileListView: FileListView { get }
    @ViewBuilder var emptyStateView: EmptyStateView { get }

    var screenTitle: LocalizedStringKey { get }
    var currentPath: String { get }
    var itemCount: Int { get }
    var onNewFile: () -> Void { get }
    var onNewFolder: () -> Void { get }
}

// MARK: - LGFileBrowserView

/// A code repository file browser template: breadcrumb nav, file list, and create actions.
public struct LGFileBrowserView<Content: LGFileBrowserContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Breadcrumb
                GlassEffectContainer(spacing: LGSpacing.xs) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        content.breadcrumbView
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.sm)

                // File list or empty state
                if content.itemCount == 0 {
                    VStack { content.emptyStateView }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List { content.fileListView }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(content.screenTitle)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    GlassEffectContainer(spacing: LGSpacing.xs) {
                        HStack(spacing: LGSpacing.xs) {
                            LGIconButton("doc.badge.plus", label: "New file", action: content.onNewFile)
                                .accessibilityHint(Text("Creates a new file in the current directory"))
                            LGIconButton("folder.badge.plus", label: "New folder", action: content.onNewFolder)
                                .accessibilityHint(Text("Creates a new folder in the current directory"))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - LGFileRow

/// A single file/folder row for use in the file browser.
public struct LGFileRow: View {

    @Environment(\.lgTheme) private var theme

    public let name: String
    public let isDirectory: Bool
    public let modified: String
    public let size: String?

    public init(name: String, isDirectory: Bool, modified: String, size: String? = nil) {
        self.name = name; self.isDirectory = isDirectory; self.modified = modified; self.size = size
    }

    public var body: some View {
        HStack(spacing: LGSpacing.sm) {
            Image(systemName: isDirectory ? "folder.fill" : fileIcon(for: name))
                .font(.body)
                .foregroundStyle(isDirectory ? .yellow : theme.colors.secondary)
                .frame(width: 24)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(theme.typography.body)
                Text(modified).font(theme.typography.label).foregroundStyle(theme.colors.secondary)
            }
            Spacer()
            if let size { Text(size).font(theme.typography.label).foregroundStyle(theme.colors.secondary) }
        }
        .padding(.vertical, LGSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(isDirectory ? "Folder" : "File") \(name)"))
    }

    private func fileIcon(for fileName: String) -> String {
        let ext = (fileName as NSString).pathExtension.lowercased()
        switch ext {
        case "swift": return "swift"
        case "json": return "curlybraces"
        case "md": return "doc.text"
        case "png", "jpg", "jpeg": return "photo"
        default: return "doc"
        }
    }
}

// MARK: - Preview

private struct FileBrowserPreviewContent: LGFileBrowserContent {
    var breadcrumbView: some View {
        HStack(spacing: LGSpacing.xs) {
            ForEach(["LiquidGlass", "Sources", "Components"], id: \.self) { part in
                HStack(spacing: LGSpacing.xs) {
                    Text(part).font(.caption.monospaced())
                    if part != "Components" {
                        Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.secondary).accessibilityHidden(true)
                    }
                }
            }
        }
    }

    var fileListView: some View {
        Group {
            LGFileRow(name: "Atoms", isDirectory: true, modified: "Today")
            LGFileRow(name: "Molecules", isDirectory: true, modified: "Yesterday")
            LGFileRow(name: "LGButton.swift", isDirectory: false, modified: "2h ago", size: "4 KB")
            LGFileRow(name: "LGCard.swift", isDirectory: false, modified: "3h ago", size: "3 KB")
        }
    }

    var emptyStateView: some View {
        Text("lg.empty.state.title").font(.body).foregroundStyle(.secondary)
    }

    var screenTitle: LocalizedStringKey { "File Browser" }
    var currentPath: String { "/LiquidGlass/Sources/Components" }
    var itemCount: Int { 4 }
    var onNewFile: () -> Void { {} }
    var onNewFolder: () -> Void { {} }
}

#Preview("File Browser") {
    LGFileBrowserView(content: FileBrowserPreviewContent())
}

#Preview("File Browser — Reduce Transparency") {
    LGFileBrowserView(content: FileBrowserPreviewContent())
        .lgPreviewReduceTransparency()
}
