// LGOnboardingView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGOnboardingContent

/// Content slot protocol for ``LGOnboardingView``.
public protocol LGOnboardingContent {
    associatedtype HeroView: View
    associatedtype FeatureListView: View

    @ViewBuilder var heroView: HeroView { get }
    @ViewBuilder var featureListView: FeatureListView { get }

    var appName: LocalizedStringKey { get }
    var tagline: LocalizedStringKey { get }
    var onGetStarted: () -> Void { get }
    var onSignIn: () -> Void { get }
}

// MARK: - LGOnboardingView

/// An onboarding / welcome template: hero, app name, feature highlights, CTA buttons.
public struct LGOnboardingView<Content: LGOnboardingContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content

    public init(content: Content) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            content.heroView
                .ignoresSafeArea()

            VStack(spacing: LGSpacing.xl) {
                Spacer()

                VStack(spacing: LGSpacing.sm) {
                    Text(content.appName)
                        .font(theme.typography.display)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.colors.onSurface)
                        .multilineTextAlignment(.center)

                    Text(content.tagline)
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, LGSpacing.xl)
                }

                content.featureListView
                    .padding(.horizontal, LGSpacing.lg)

                Spacer()

                GlassEffectContainer(spacing: LGSpacing.sm) {
                    VStack(spacing: LGSpacing.sm) {
                        LGButton("lg.auth.login.title", style: .glassProminent, action: content.onGetStarted)
                            .frame(maxWidth: .infinity)
                        LGButton("lg.auth.signup.title", style: .glass, action: content.onSignIn)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, LGSpacing.lg)
                }
                .padding(.bottom, LGSpacing.xl)
            }
        }
    }
}

// MARK: - LGLoginView

// MARK: - LGLoginContent

/// Content slot protocol for ``LGLoginView``.
public protocol LGLoginContent {
    var onLogin: (_ email: String, _ password: String) -> Void { get }
    var onForgotPassword: () -> Void { get }
    var onSignUp: () -> Void { get }
    var screenTitle: LocalizedStringKey { get }
}

// MARK: - LGLoginView

/// A login template with email/password fields and glass CTA buttons.
public struct LGLoginView<Content: LGLoginContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    @State private var email = ""
    @State private var password = ""

    private let content: Content

    public init(content: Content) {
        self.content = content
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LGSpacing.xl) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(theme.colors.primary)
                        .padding(.top, LGSpacing.xxl)
                        .accessibilityHidden(true)

                    VStack(spacing: LGSpacing.md) {
                        LGTextField("Email address", text: $email, systemImage: "envelope")
                        LGTextField("Password", text: $password, systemImage: "lock", isSecure: true)
                    }
                    .padding(.horizontal, LGSpacing.lg)

                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        VStack(spacing: LGSpacing.sm) {
                            LGButton("lg.auth.login.title", style: .glassProminent) {
                                content.onLogin(email, password)
                            }
                            .frame(maxWidth: .infinity)

                            LGButton("Forgot Password?", style: .glass) {
                                content.onForgotPassword()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, LGSpacing.lg)
                    }

                    Spacer()

                    LGButton("lg.auth.signup.title", style: .glass) {
                        content.onSignUp()
                    }
                    .padding(.bottom, LGSpacing.xl)
                }
            }
            .navigationTitle(content.screenTitle)
        }
    }
}

// MARK: - Preview

private struct OnboardingPreviewContent: LGOnboardingContent {
    var heroView: some View {
        LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var featureListView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.md) {
            Label("Liquid Glass Design", systemImage: "sparkles")
            Label("Adaptive Theming", systemImage: "paintbrush.fill")
            Label("Full Accessibility", systemImage: "accessibility")
        }
        .font(.body)
        .foregroundStyle(.primary)
    }

    var appName: LocalizedStringKey { "LiquidGlass" }
    var tagline: LocalizedStringKey { "Beautiful Apple Platform apps" }
    var onGetStarted: () -> Void { {} }
    var onSignIn: () -> Void { {} }
}

private struct LoginPreviewContent: LGLoginContent {
    var onLogin: (String, String) -> Void { { _, _ in } }
    var onForgotPassword: () -> Void { {} }
    var onSignUp: () -> Void { {} }
    var screenTitle: LocalizedStringKey { "lg.auth.login.title" }
}

#Preview("Onboarding") {
    LGOnboardingView(content: OnboardingPreviewContent())
}

#Preview("Login") {
    LGLoginView(content: LoginPreviewContent())
}

#Preview("Login — Reduce Transparency") {
    LGLoginView(content: LoginPreviewContent())
        .lgPreviewReduceTransparency()
}
