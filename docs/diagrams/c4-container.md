# C4 Level 2 — Container Diagram

```mermaid
C4Container
    title LiquidGlass Framework — Internal Containers

    System_Boundary(lg, "LiquidGlass Framework") {

        Container(core, "Core", "Swift", "Foundation layer. LGTheme, LGColors, LGTypography, LGSpacing, LGShape. View+Glass extensions. LiquidGlass.xcstrings localization. No external dependencies.")

        Container(atoms, "Components/Atoms", "SwiftUI", "Atomic building blocks. LGButton, LGIconButton, LGAvatar, LGTextField, LGBadge, LGTag, LGProgressIndicators, LGStatLabel. Depend only on Core.")

        Container(molecules, "Components/Molecules", "SwiftUI", "Composed components with presentation logic. LGCard, LGListRow, LGSearchBar, LGToast, LGBanner, LGToolbarGroup. Domain rows: Transaction, Score, Product, Lesson, League. Depend on Atoms + Core.")

        Container(organisms, "Components/Organisms", "SwiftUI", "Full reusable layouts. LGTabScaffold, LGBottomSheet, LGModal, LGSplitLayout, LGHeroDetail. Depend on Molecules + Atoms + Core.")

        Container(templates, "Templates", "SwiftUI", "Domain screen templates (12 domains, 30+ screens). Each has a Protocol + View + @ViewBuilder slots. Banking, Learning, Gaming, Sports, Betting, Insurance, Shopping, Library, Code, News, Auth, Settings. Depend on Organisms + all.")

        Container(animations, "Animations", "Swift", "LGAnimations (springs, durations). LGTransitions (materialize, matchedMorph, slideUp). LGMorphModifier. Depend only on Core.")

        Container(scripts, "Scripts", "Shell", "build-xcframework.sh. Builds all platform slices and assembles LiquidGlass.xcframework.")

        Container(docs, "LiquidGlass.docc", "DocC", "API documentation. Articles: GettingStarted, Theming, BuildingTemplates, CreatingComponents. Tutorial: BankingApp.")
    }

    Rel(atoms, core, "Imports")
    Rel(molecules, atoms, "Imports")
    Rel(molecules, core, "Imports")
    Rel(organisms, molecules, "Imports")
    Rel(organisms, atoms, "Imports")
    Rel(organisms, core, "Imports")
    Rel(templates, organisms, "Imports")
    Rel(templates, molecules, "Imports")
    Rel(templates, atoms, "Imports")
    Rel(templates, core, "Imports")
    Rel(animations, core, "Imports")
```

## Dependency rules
- Core has zero inward dependencies. It is the foundation.
- Atoms → Core only.
- Molecules → Atoms + Core.
- Organisms → Molecules + Atoms + Core.
- Templates → everything below. Never import other Templates.
- Animations → Core only.
- Scripts and Docs have no Swift dependencies.
