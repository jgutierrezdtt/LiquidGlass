// LGBanner.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBanner

/// A persistent top-of-screen informational banner.
///
/// Unlike ``LGToast`` (transient), banners stay visible until explicitly dismissed.
/// Use the `.lgBanner(_:isPresented:)` modifier.
///
/// ```swift
/// ContentView()
///     .lgBanner(LGBannerData(title: "Maintenance scheduled", message: "Sunday 2–4 AM", severity: .warning), isPresented: $showBanner)
/// ```
public struct LGBanner: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let data: LGBannerData
    private let onDismiss: (() -> Void)?

    public init(data: LGBannerData, onDismiss: (() -> Void)? = nil) {
        self.data = data
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: LGSpacing.sm) {
            Image(systemName: data.severity.systemImage)
                .foregroundStyle(tintColor)
                .font(theme.typography.body)
                .padding(.top, 2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: LGSpacing.xs) {
                Text(data.title)
                    .font(theme.typography.body.weight(.semibold))
                    .foregroundStyle(theme.colors.onSurface)

                if let message = data.message {
                    Text(message)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.secondary)
                }
            }

            Spacer()

            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(theme.typography.label.weight(.semibold))
                        .foregroundStyle(theme.colors.secondary)
                        .accessibilityLabel(Text("lg.button.close", bundle: .lg))
                }
            }
        }
        .padding(.horizontal, LGSpacing.md)
        .padding(.vertical, LGSpacing.sm + 2)
        .background(bannerBackground)
        .transition(LGTransitions.slideUp)
    }

    private var tintColor: Color {
        data.severity.tintColor(theme: theme)
    }

    @ViewBuilder
    private var bannerBackground: some View {
        if reduceTransparency {
            LGShape.rounded(.md)
                .fill(theme.colors.surface.opacity(0.95))
        } else {
            LGShape.rounded(.md)
                .fill(.clear)
                .glassEffect(.regular.tint(tintColor).interactive(), in: .rect(cornerRadius: .lgRadius(.md)))
        }
    }
}

// MARK: - LGBannerData

/// The data model for an ``LGBanner``.
public struct LGBannerData {
    public let title: LocalizedStringKey
    public let message: LocalizedStringKey?
    public let severity: LGToastSeverity

    public init(title: LocalizedStringKey, message: LocalizedStringKey? = nil, severity: LGToastSeverity = .info) {
        self.title = title
        self.message = message
        self.severity = severity
    }
}

// MARK: - View modifier

public extension View {
    /// Presents an ``LGBanner`` pinned to the top safe area edge.
    /// - Parameters:
    ///   - data: The banner data to display.
    ///   - isPresented: Controls visibility.
    func lgBanner(_ data: LGBannerData, isPresented: Binding<Bool>) -> some View {
        safeAreaInset(edge: .top) {
            if isPresented.wrappedValue {
                LGBanner(data: data) {
                    withAnimation(LGAnimations.snappy) {
                        isPresented.wrappedValue = false
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.top, LGSpacing.sm)
            }
        }
        .animation(LGAnimations.snappy, value: isPresented.wrappedValue)
    }
}

// MARK: - Preview

private struct LGBannerPreview: View {
    @State private var show = true

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            LGButton("Toggle Banner") {
                withAnimation(LGAnimations.snappy) { show.toggle() }
            }
        }
        .lgBanner(
            LGBannerData(title: "Maintenance scheduled", message: "Sunday 2–4 AM", severity: .warning),
            isPresented: $show
        )
    }
}

#Preview("Banner") {
    LGBannerPreview()
}
