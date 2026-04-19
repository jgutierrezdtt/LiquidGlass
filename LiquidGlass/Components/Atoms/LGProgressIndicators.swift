// LGProgressIndicators.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGProgressBar

/// A horizontal progress bar with a glass track and a filled progress segment.
///
/// ```swift
/// LGProgressBar(value: 0.65, label: "Course completion")
/// ```
public struct LGProgressBar: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let value: Double      // 0.0 … 1.0
    private let label: LocalizedStringKey?
    private let tint: Color?
    private let height: CGFloat

    /// Creates an ``LGProgressBar``.
    /// - Parameters:
    ///   - value: Progress from `0.0` (empty) to `1.0` (full).
    ///   - label: Optional localized accessibility label.
    ///   - tint: Optional override color for the filled track.
    ///   - height: Bar height. Defaults to `6`.
    public init(
        value: Double,
        label: LocalizedStringKey? = nil,
        tint: Color? = nil,
        height: CGFloat = 6
    ) {
        self.value = max(0, min(1, value))
        self.label = label
        self.tint = tint
        self.height = height
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(theme.colors.surface.opacity(reduceTransparency ? 0.5 : 0.3))
                    .frame(height: height)

                // Fill
                Capsule()
                    .fill(fillColor)
                    .frame(width: geo.size.width * value, height: height)
                    .animation(reduceMotion ? nil : LGAnimations.smooth, value: value)
            }
        }
        .frame(height: height)
        .accessibilityLabel(Text(label ?? "lg.progress.label"))
        .accessibilityValue(Text("\(Int(value * 100)) percent"))
    }

    private var fillColor: Color {
        tint ?? theme.colors.primary
    }
}

// MARK: - LGProgressRing

/// A circular progress ring for compact progress representations.
///
/// ```swift
/// LGProgressRing(value: 0.72, size: 56)
/// ```
public struct LGProgressRing: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let value: Double      // 0.0 … 1.0
    private let size: CGFloat
    private let lineWidth: CGFloat
    private let label: LocalizedStringKey?
    private let tint: Color?
    private let centerContent: AnyView?

    /// Creates an ``LGProgressRing``.
    /// - Parameters:
    ///   - value: Progress from `0.0` to `1.0`.
    ///   - size: Outer diameter of the ring in points. Defaults to `56`.
    ///   - lineWidth: Stroke width. Defaults to `4`.
    ///   - label: Optional localized accessibility label.
    ///   - tint: Optional override color for the ring arc.
    public init(
        value: Double,
        size: CGFloat = 56,
        lineWidth: CGFloat = 4,
        label: LocalizedStringKey? = nil,
        tint: Color? = nil
    ) {
        self.value = max(0, min(1, value))
        self.size = size
        self.lineWidth = lineWidth
        self.label = label
        self.tint = tint
        self.centerContent = nil
    }

    public var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(
                    theme.colors.surface.opacity(reduceTransparency ? 0.4 : 0.25),
                    lineWidth: lineWidth
                )

            // Progress arc
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    fillColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(reduceMotion ? nil : LGAnimations.bounce, value: value)

            // Percentage label
            Text("\(Int(value * 100))%")
                .font(theme.typography.label.weight(.semibold))
                .foregroundStyle(theme.colors.onSurface)
        }
        .frame(width: size, height: size)
        .accessibilityLabel(Text(label ?? "lg.progress.label"))
        .accessibilityValue(Text("\(Int(value * 100)) percent"))
    }

    private var fillColor: Color {
        tint ?? theme.colors.primary
    }
}

// MARK: - Preview

#Preview("Progress Indicators") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        VStack(spacing: LGSpacing.xl) {
            VStack(spacing: LGSpacing.sm) {
                LGProgressBar(value: 0.3)
                LGProgressBar(value: 0.65)
                LGProgressBar(value: 1.0)
            }
            .padding()

            HStack(spacing: LGSpacing.xl) {
                LGProgressRing(value: 0.25, size: 56)
                LGProgressRing(value: 0.65, size: 72)
                LGProgressRing(value: 1.0, size: 56)
            }
        }
        .padding()
    }
}
