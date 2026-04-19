# C4 Level 1 — Context Diagram

```mermaid
C4Context
    title LiquidGlass Framework — System Context

    Person(developer, "App Developer", "iOS/macOS/tvOS/watchOS developer building an app with Liquid Glass UI")

    System_Boundary(lg, "LiquidGlass Framework") {
        System(lgFramework, "LiquidGlass.xcframework", "Private Swift framework. Provides Liquid Glass UI components, animations, and screen templates. iOS/macOS/tvOS/watchOS 26+.")
    }

    System_Ext(swiftui, "SwiftUI + Apple SDKs", "GlassEffectContainer, glassEffect(), GlassEffectTransition, TabView, NavigationSplitView, etc.")
    System_Ext(consumerApp, "Consumer App", "Any iOS/macOS/tvOS/watchOS 26+ app that embeds LiquidGlass.xcframework")
    System_Ext(xcode, "Xcode 26", "Build toolchain, DocC documentation renderer, Preview engine")

    Rel(developer, xcode, "Develops with")
    Rel(developer, consumerApp, "Builds")
    Rel(consumerApp, lgFramework, "Embeds & imports", "XCFramework binary")
    Rel(lgFramework, swiftui, "Extends & composes")
    Rel(xcode, lgFramework, "Builds, previews, generates DocC")
```

## Description
The developer builds a consumer app that embeds the `LiquidGlass.xcframework` binary. The framework is built on top of SwiftUI and Apple's Liquid Glass APIs. The developer uses Xcode 26 to build, preview components, and browse the DocC documentation catalog.
