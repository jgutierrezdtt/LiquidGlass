// LGBottomSheet.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGBottomSheet

/// A bottom sheet organism using `.sheet` with glass detents.
///
/// Accepts a `@ViewBuilder` content closure. Detents default to `.medium` and `.large`.
///
/// ```swift
/// ContentView()
///     .lgBottomSheet(isPresented: $showSheet) {
///         MySheetContent()
///     }
/// ```
public struct LGBottomSheetModifier<SheetContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    private let detents: Set<PresentationDetent>
    private let sheetContent: SheetContent

    public init(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.sheetContent = content()
    }

    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            sheetContent
                .presentationDetents(detents)
                .presentationDragIndicator(.visible)
                .presentationBackground(.regularMaterial)
                .accessibilityAddTraits(.isModal)
        }
    }
}

// MARK: - View extension

public extension View {
    /// Presents a Liquid Glass bottom sheet.
    /// - Parameters:
    ///   - isPresented: Controls sheet visibility.
    ///   - detents: The allowed height detents. Defaults to `.medium` and `.large`.
    ///   - content: `@ViewBuilder` sheet body content.
    func lgBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(LGBottomSheetModifier(isPresented: isPresented, detents: detents, content: content))
    }
}

// MARK: - Preview

private struct LGBottomSheetPreview: View {
    @State private var show = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            LGButton("Open Sheet") { withAnimation(LGAnimations.snappy) { show = true } }
        }
        .lgBottomSheet(isPresented: $show) {
            VStack(alignment: .leading, spacing: LGSpacing.md) {
                Text("Sheet Content")
                    .font(.headline)
                    .padding(.top, LGSpacing.md)
                Text("This is the bottom sheet body. Swipe down or tap outside to dismiss.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview("Bottom Sheet") {
    LGBottomSheetPreview()
}
