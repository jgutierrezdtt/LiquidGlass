// LGIssueListView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGIssueListContent

/// Content slot protocol for ``LGIssueListView``.
public protocol LGIssueListContent {
    associatedtype FilterBarView: View
    associatedtype IssueListBodyView: View

    @ViewBuilder var filterBarView: FilterBarView { get }
    @ViewBuilder var issueListBodyView: IssueListBodyView { get }

    var screenTitle: LocalizedStringKey { get }
    var openCount: Int { get }
    var closedCount: Int { get }
    var onNewIssue: () -> Void { get }
}

// MARK: - LGIssueListView

/// A code repository issue list template: open/closed counts, filter bar, and issue list.
public struct LGIssueListView<Content: LGIssueListContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @State private var showingOpen = true
    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Open/Closed toggle
                GlassEffectContainer(spacing: LGSpacing.sm) {
                    HStack(spacing: LGSpacing.sm) {
                        Button {
                            withAnimation(LGAnimations.snappy) { showingOpen = true }
                        } label: {
                            Label("\(content.openCount) Open", systemImage: "circle")
                                .font(theme.typography.body)
                                .padding(.horizontal, LGSpacing.md)
                                .padding(.vertical, LGSpacing.sm)
                        }
                        .buttonStyle(showingOpen ? .glassProminent : .glassProminent)
                        .opacity(showingOpen ? 1 : 0.6)
                        .accessibilityLabel(Text("Show open issues"))

                        Button {
                            withAnimation(LGAnimations.snappy) { showingOpen = false }
                        } label: {
                            Label("\(content.closedCount) Closed", systemImage: "checkmark.circle")
                                .font(theme.typography.body)
                                .padding(.horizontal, LGSpacing.md)
                                .padding(.vertical, LGSpacing.sm)
                        }
                        .buttonStyle(showingOpen ? .glass : .glass)
                        .opacity(showingOpen ? 0.6 : 1)
                        .accessibilityLabel(Text("Show closed issues"))
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.sm)

                // Filter bar
                content.filterBarView
                    .padding(.horizontal, LGSpacing.md)
                    .padding(.top, LGSpacing.sm)

                // Issue list
                List { content.issueListBodyView }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
            }
            .navigationTitle(content.screenTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LGIconButton("plus", label: "New issue", action: content.onNewIssue)
                        .accessibilityHint(Text("Creates a new issue in this repository"))
                }
            }
        }
    }
}

// MARK: - LGIssueRow

/// A single issue row for use in the issue list.
public struct LGIssueRow: View {

    @Environment(\.lgTheme) private var theme

    public let number: Int
    public let title: String
    public let labels: [String]
    public let author: String
    public let timeAgo: String
    public let isOpen: Bool
    public let commentCount: Int

    public init(number: Int, title: String, labels: [String] = [], author: String, timeAgo: String, isOpen: Bool = true, commentCount: Int = 0) {
        self.number = number; self.title = title; self.labels = labels
        self.author = author; self.timeAgo = timeAgo; self.isOpen = isOpen; self.commentCount = commentCount
    }

    public var body: some View {
        HStack(alignment: .top, spacing: LGSpacing.sm) {
            Image(systemName: isOpen ? "circle" : "checkmark.circle.fill")
                .foregroundStyle(isOpen ? .green : .purple)
                .accessibilityLabel(Text(isOpen ? "Open" : "Closed"))

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(title).font(theme.typography.body)
                HStack(spacing: LGSpacing.xs) {
                    Text("#\(number)").font(.caption.monospaced()).foregroundStyle(.secondary)
                    Text("by \(author)").font(.caption).foregroundStyle(.secondary)
                    Text("· \(timeAgo)").font(.caption).foregroundStyle(.secondary)
                }
                if !labels.isEmpty {
                    HStack(spacing: LGSpacing.xs) {
                        ForEach(labels, id: \.self) { label in
                            LGTag(LocalizedStringKey(label), style: .surface)
                        }
                    }
                }
            }

            Spacer()

            if commentCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right").font(.caption).accessibilityHidden(true)
                    Text("\(commentCount)").font(.caption)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, LGSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Issue #\(number) \(title) by \(author), \(timeAgo)"))
    }
}

// MARK: - Preview

private struct IssueListPreviewContent: LGIssueListContent {
    var filterBarView: some View {
        LGSearchBar(text: .constant(""))
    }

    var issueListBodyView: some View {
        Group {
            LGIssueRow(number: 42, title: "Glass effect flickers on iPad", labels: ["bug", "glass"], author: "jgl", timeAgo: "2h ago", isOpen: true, commentCount: 3)
            LGIssueRow(number: 41, title: "Add LGReaderView template", labels: ["enhancement"], author: "miko", timeAgo: "1d ago", isOpen: true, commentCount: 1)
            LGIssueRow(number: 40, title: "LGButton glassProminent on tvOS", labels: ["bug", "tvOS"], author: "alex", timeAgo: "3d ago", isOpen: false, commentCount: 5)
        }
    }

    var screenTitle: LocalizedStringKey { "Issues" }
    var openCount: Int { 2 }
    var closedCount: Int { 1 }
    var onNewIssue: () -> Void { {} }
}

#Preview("Issue List") {
    LGIssueListView(content: IssueListPreviewContent())
}

#Preview("Issue List — Reduce Transparency") {
    LGIssueListView(content: IssueListPreviewContent())
        .lgPreviewReduceTransparency()
}
