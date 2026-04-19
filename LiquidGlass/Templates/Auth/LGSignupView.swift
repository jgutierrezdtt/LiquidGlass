// LGSignupView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGSignupContent

/// Content slot protocol for ``LGSignupView``.
public protocol LGSignupContent {
    associatedtype HeroView: View
    associatedtype SocialSignupView: View

    @ViewBuilder var heroView: HeroView { get }
    @ViewBuilder var socialSignupView: SocialSignupView { get }

    var appName: LocalizedStringKey { get }
    var nameBinding: Binding<String> { get }
    var emailBinding: Binding<String> { get }
    var passwordBinding: Binding<String> { get }
    var confirmPasswordBinding: Binding<String> { get }
    var canSignUp: Bool { get }
    var onSignUp: () -> Void { get }
    var onLogin: () -> Void { get }
}

// MARK: - LGSignupView

/// A sign-up / registration template with name, email, password fields, social options, and T&C.
public struct LGSignupView<Content: LGSignupContent>: View {

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
            ScrollView {
                VStack(spacing: LGSpacing.xl) {
                    // Hero
                    content.heroView
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, LGSpacing.md)

                    // Title
                    VStack(spacing: LGSpacing.xs) {
                        Text("lg.auth.signup.title")
                            .font(theme.typography.display)
                            .foregroundStyle(theme.colors.onSurface)
                        Text(content.appName)
                            .font(theme.typography.title)
                            .foregroundStyle(theme.colors.secondary)
                    }
                    .multilineTextAlignment(.center)

                    // Social sign-up
                    content.socialSignupView
                        .padding(.horizontal, LGSpacing.md)

                    // Divider
                    HStack(spacing: LGSpacing.md) {
                        Rectangle().fill(theme.colors.secondary.opacity(0.3)).frame(height: 1)
                            .accessibilityHidden(true)
                        Text("or").font(theme.typography.label).foregroundStyle(theme.colors.secondary)
                        Rectangle().fill(theme.colors.secondary.opacity(0.3)).frame(height: 1)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // Form
                    GlassEffectContainer(spacing: LGSpacing.sm) {
                        VStack(spacing: LGSpacing.sm) {
                            LGTextField("Full Name", text: content.nameBinding, systemImage: "person")
                            LGTextField("Email", text: content.emailBinding, systemImage: "envelope")
                            LGTextField("Password", text: content.passwordBinding, systemImage: "lock", isSecure: true)
                            LGTextField("Confirm Password", text: content.confirmPasswordBinding, systemImage: "lock", isSecure: true)
                        }
                        .padding(LGSpacing.sm)
                    }
                    .padding(.horizontal, LGSpacing.md)

                    // CTA
                    LGButton("lg.auth.signup.title", style: content.canSignUp ? .glassProminent : .glass, action: content.onSignUp)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, LGSpacing.lg)
                        .disabled(!content.canSignUp)
                        .accessibilityHint(Text("Creates your new account"))

                    // Already have account
                    HStack(spacing: LGSpacing.xs) {
                        Text("Already have an account?")
                            .font(theme.typography.body)
                            .foregroundStyle(theme.colors.secondary)
                        Button {
                            content.onLogin()
                        } label: {
                            Text("lg.auth.login.title")
                                .font(theme.typography.body.weight(.semibold))
                                .foregroundStyle(theme.colors.accent)
                        }
                        .accessibilityHint(Text("Navigates to the sign in screen"))
                    }
                    .padding(.bottom, LGSpacing.xl)
                }
                .padding(.top, LGSpacing.lg)
            }
        }
    }
}

// MARK: - Preview

private struct SignupPreviewContent: LGSignupContent {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirm = ""

    var heroView: some View {
        LGCard(.hero) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
                .frame(maxWidth: .infinity)
        }
    }

    var socialSignupView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            HStack(spacing: LGSpacing.sm) {
                LGButton("Apple", systemImage: "applelogo", style: .glass) {}
                    .frame(maxWidth: .infinity)
                LGButton("Google", systemImage: "globe", style: .glass) {}
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var appName: LocalizedStringKey { "My App" }
    var nameBinding: Binding<String> { $name }
    var emailBinding: Binding<String> { $email }
    var passwordBinding: Binding<String> { $password }
    var confirmPasswordBinding: Binding<String> { $confirm }
    var canSignUp: Bool { !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirm }
    var onSignUp: () -> Void { {} }
    var onLogin: () -> Void { {} }
}

#Preview("Sign Up") {
    LGSignupView(content: SignupPreviewContent())
}

#Preview("Sign Up — Reduce Transparency") {
    LGSignupView(content: SignupPreviewContent())
        .lgPreviewReduceTransparency()
}
