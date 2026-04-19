// LGAvatar.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGAvatar

/// A circular avatar atom that displays either an image or initials with a glass ring.
///
/// ```swift
/// LGAvatar(initials: "JG", size: .large)
/// LGAvatar(image: Image("profile"), size: .medium)
/// ```
public struct LGAvatar: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }

    private let content: AvatarContent
    private let size: LGAvatarSize
    private let accessibilityLabel: LocalizedStringKey?

    // MARK: Init — initials

    /// Creates an ``LGAvatar`` showing text initials.
    /// - Parameters:
    ///   - initials: Up to 2 characters displayed in the circle.
    ///   - size: The avatar size tier. Defaults to `.medium`.
    ///   - accessibilityLabel: Override the default accessibility label.
    public init(
        initials: String,
        size: LGAvatarSize = .medium,
        accessibilityLabel: LocalizedStringKey? = nil
    ) {
        self.content = .initials(String(initials.prefix(2)))
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    /// Creates an ``LGAvatar`` showing a SwiftUI `Image`.
    /// - Parameters:
    ///   - image: The image to display.
    ///   - size: The avatar size tier. Defaults to `.medium`.
    ///   - accessibilityLabel: Override the default accessibility label.
    public init(
        image: Image,
        size: LGAvatarSize = .medium,
        accessibilityLabel: LocalizedStringKey? = nil
    ) {
        self.content = .image(image)
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    // MARK: Body

    public var body: some View {
        avatarBody
            .frame(width: size.dimension, height: size.dimension)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(ringStyle, lineWidth: 2))
            .accessibilityLabel(Text(accessibilityLabel ?? "lg.avatar.placeholder"))
    }

    // MARK: Private

    @ViewBuilder
    private var avatarBody: some View {
        switch content {
        case .initials(let text):
            Circle()
                .fill(theme.colors.surface)
                .overlay {
                    Text(text)
                        .font(initialsFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.colors.primary)
                }
        case .image(let img):
            img
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }

    private var initialsFont: Font {
        switch size {
        case .small: return theme.typography.label
        case .medium: return theme.typography.caption
        case .large: return theme.typography.body
        case .hero: return theme.typography.title
        }
    }

    private var ringStyle: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(theme.colors.surface.opacity(0.6))
        } else {
            return AnyShapeStyle(.regularMaterial)
        }
    }
}

// MARK: - AvatarContent

private enum AvatarContent {
    case initials(String)
    case image(Image)
}

// MARK: - LGAvatarSize

/// Named size tiers for ``LGAvatar``.
public enum LGAvatarSize {
    /// 32 pt — compact list rows and tight layouts.
    case small
    /// 44 pt — standard list rows and cards.
    case medium
    /// 64 pt — profile headers and prominent contexts.
    case large
    /// 88 pt — hero profile sections.
    case hero

    var dimension: CGFloat {
        switch self { case .small: 32; case .medium: 44; case .large: 64; case .hero: 88 }
    }
}

// MARK: - Preview

#Preview("Avatars") {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        HStack(spacing: LGSpacing.lg) {
            LGAvatar(initials: "JG", size: .small)
            LGAvatar(initials: "AB", size: .medium)
            LGAvatar(initials: "MK", size: .large)
            LGAvatar(initials: "XY", size: .hero)
        }
        .padding()
    }
}
