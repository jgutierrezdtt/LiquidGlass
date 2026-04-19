// LGModal.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGModal

/// A full-screen modal overlay organism with a `materialize` glass transition.
///
/// Use the `.lgModal(isPresented:content:)` modifier rather than placing this view directly.
///
/// ```swift
/// ContentView()
///     .lgModal(isPresented: $showModal) {
///         MyModalContent()
///     }
/// ```
public struct LGModal<ModalContent: View>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    @Binding var isPresented: Bool
    private let title: LocalizedStringKey?
    private let modalContent: ModalContent

    public init(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> ModalContent
    ) {
        self._isPresented = isPresented
        self.title = title
        self.modalContent = content()
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background scrim
            if reduceTransparency {
                theme.colors.surface.opacity(0.98)
                    .ignoresSafeArea()
            } else {
                Rectangle()
                    .fill(.regularMaterial)
                    .ignoresSafeArea()
            }

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: LGSpacing.md) {
                    if let title {
                        Text(title)
                            .font(theme.typography.headline)
                            .foregroundStyle(theme.colors.onSurface)
                            .padding(.top, LGSpacing.xl)
                    }
                    modalContent
                }
                .padding(.horizontal, LGSpacing.lg)
                .padding(.bottom, LGSpacing.xxl)
            }

            // Dismiss button
            Button {
                withAnimation(reduceMotion ? .default : LGAnimations.snappy) {
                    isPresented = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(theme.colors.secondary)
                    .accessibilityLabel(Text("lg.button.close", bundle: .lg))
                    .accessibilityHint(Text("lg.accessibility.close.hint", bundle: .lg))
            }
            .padding([.top, .trailing], LGSpacing.lg)
        }
        .accessibilityAddTraits(.isModal)
    }
}

// MARK: - View extension

public extension View {
    /// Presents an ``LGModal`` overlay with `materialize` transition.
    func lgModal<Content: View>(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            LGModal(isPresented: isPresented, title: title, content: content)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
    }
}

// MARK: - Preview

private struct LGModalPreview: View {
    @State private var show = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            LGButton("Open Modal") { show = true }
        }
        .lgModal(isPresented: $show, title: "Details") {
            Text("This is full-screen modal content with a materialize glass transition.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Modal") {
    LGModalPreview()
}
