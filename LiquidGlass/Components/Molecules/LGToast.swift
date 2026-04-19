// LGToast.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGToastSeverity

/// Semantic severity levels for ``LGToast`` and ``LGBanner``.
public enum LGToastSeverity {
    /// Neutral informational message.
    case info
    /// Operation succeeded.
    case success
    /// Non-blocking warning.
    case warning
    /// Error or failure.
    case error

    func tintColor(theme: any LGThemeProtocol) -> Color {
        switch self {
        case .info: return theme.colors.secondary
        case .success: return Color.green
        case .warning: return Color.orange
        case .error: return theme.colors.destructive
        }
    }

    var systemImage: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

// MARK: - LGToast

/// A transient notification that appears at the bottom of the screen.
///
/// Use the `.lgToast(_:isPresented:)` view modifier instead of placing this directly.
///
/// ```swift
/// ContentView()
///     .lgToast(LGToastData(message: "Sent!", severity: .success), isPresented: $showToast)
/// ```
public struct LGToast: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let data: LGToastData
    private let onDismiss: () -> Void

    public init(data: LGToastData, onDismiss: @escaping () -> Void) {
        self.data = data
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: LGSpacing.sm) {
            Image(systemName: data.severity.systemImage)
                .foregroundStyle(tintColor)
                .font(theme.typography.body)
                .accessibilityHidden(true)

            Text(data.message)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
                .lineLimit(2)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(theme.typography.label.weight(.semibold))
                    .foregroundStyle(theme.colors.secondary)
                    .accessibilityLabel(Text("lg.button.close", bundle: .lg))
                    .accessibilityHint(Text("lg.toast.dismiss.hint", bundle: .lg))
            }
        }
        .padding(.horizontal, LGSpacing.md)
        .padding(.vertical, LGSpacing.sm + 2)
        .background(toastBackground)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var tintColor: Color {
        data.severity.tintColor(theme: theme)
    }

    @ViewBuilder
    private var toastBackground: some View {
        if reduceTransparency {
            Capsule().fill(theme.colors.surface.opacity(0.95))
        } else {
            Capsule().fill(.clear)
                .glassEffect(.regular.tint(tintColor))
        }
    }
}

// MARK: - LGToastData

/// The data model for an ``LGToast``.
public struct LGToastData: Equatable {
    public let message: LocalizedStringKey
    public let severity: LGToastSeverity

    public init(message: LocalizedStringKey, severity: LGToastSeverity = .info) {
        self.message = message
        self.severity = severity
    }

    public static func == (lhs: LGToastData, rhs: LGToastData) -> Bool {
        lhs.severity == rhs.severity
    }
}

extension LGToastSeverity: Equatable {}

// MARK: - View modifier

public extension View {
    /// Presents an ``LGToast`` overlay at the bottom safe area edge.
    /// - Parameters:
    ///   - data: The toast data to display.
    ///   - isPresented: Controls visibility.
    func lgToast(_ data: LGToastData, isPresented: Binding<Bool>) -> some View {
        safeAreaInset(edge: .bottom) {
            if isPresented.wrappedValue {
                LGToast(data: data) {
                    withAnimation(LGAnimations.snappy) {
                        isPresented.wrappedValue = false
                    }
                }
                .padding(.horizontal, LGSpacing.md)
                .padding(.bottom, LGSpacing.sm)
            }
        }
        .animation(LGAnimations.snappy, value: isPresented.wrappedValue)
    }
}

// MARK: - Preview

private struct LGToastPreview: View {
    @State private var show = true

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            VStack {
                LGButton("Show Toast") {
                    withAnimation(LGAnimations.snappy) { show = true }
                }
            }
        }
        .lgToast(LGToastData(message: "Payment sent!", severity: .success), isPresented: $show)
    }
}

#Preview("Toast") {
    LGToastPreview()
}
