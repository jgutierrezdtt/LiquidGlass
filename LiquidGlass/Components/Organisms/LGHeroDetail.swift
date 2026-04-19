// LGHeroDetail.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGHeroDetailContent

/// Content slot protocol for ``LGHeroDetail``.
public protocol LGHeroDetailContent {
    associatedtype HeroView: View
    associatedtype BodyView: View
    associatedtype ActionsView: View

    /// Edge-to-edge hero image or gradient displayed at the top.
    @ViewBuilder var heroView: HeroView { get }
    /// Main body content rendered below the hero in a scroll view.
    @ViewBuilder var bodyView: BodyView { get }
    /// Floating action buttons shown over the hero (up to 3 recommended).
    @ViewBuilder var actionsView: ActionsView { get }

    /// The navigation bar title (used when the hero collapses on scroll).
    var navigationTitle: LocalizedStringKey { get }
}

// MARK: - LGHeroDetail

/// A hero-detail organism: edge-to-edge hero image, scroll collapse, glass navbar overlay.
///
/// ```swift
/// struct MyHeroContent: LGHeroDetailContent {
///     var heroView: some View { Image("hero").resizable().aspectRatio(contentMode: .fill) }
///     var bodyView: some View { BodyContent() }
///     var actionsView: some View {
///         LGToolbarGroup {
///             LGIconButton("heart", label: "Like") {}
///             LGIconButton("square.and.arrow.up", label: "Share") {}
///         }
///     }
///     var navigationTitle: LocalizedStringKey { "Profile" }
/// }
///
/// LGHeroDetail(content: MyHeroContent())
/// ```
public struct LGHeroDetail<Content: LGHeroDetailContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let content: Content
    private let heroHeight: CGFloat

    /// Creates an ``LGHeroDetail``.
    /// - Parameters:
    ///   - content: The content slots for this screen.
    ///   - heroHeight: Height of the hero image area. Defaults to `320`.
    public init(content: Content, heroHeight: CGFloat = 320) {
        self.content = content
        self.heroHeight = heroHeight
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                content.bodyView
                    .padding(.top, LGSpacing.lg)
            }
        }
        .scrollEdgeEffectStyle(.hard, for: .top)
        .ignoresSafeArea(edges: .top)
        .navigationTitle(content.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                content.actionsView
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            content.heroView
                .frame(height: heroHeight)
                .clipped()

            // Gradient overlay for text legibility
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: heroHeight)
            .allowsHitTesting(false)
        }
        .frame(height: heroHeight)
    }
}

// MARK: - Preview

private struct HeroPreviewContent: LGHeroDetailContent {
    var heroView: some View {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var bodyView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.md) {
            Text("Hero content follows here. Add cards, stats, and lists.")
                .font(.body)
                .padding(.horizontal)
        }
    }

    var actionsView: some View {
        LGToolbarGroup {
            LGIconButton("heart", label: "Like") {}
            LGIconButton("square.and.arrow.up", label: "Share") {}
        }
    }

    var navigationTitle: LocalizedStringKey { "Detail" }
}

#Preview("Hero Detail") {
    NavigationStack {
        LGHeroDetail(content: HeroPreviewContent())
    }
}
