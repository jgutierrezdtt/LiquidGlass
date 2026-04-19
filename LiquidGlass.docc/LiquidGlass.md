# ``LiquidGlass``

A private Swift framework providing reusable Liquid Glass UI components, animations, and screen templates for Apple platforms.

## Overview

LiquidGlass is built around four principles:

- **Theme-agnostic** — all colors and fonts come from your `LGThemeProtocol` implementation. No hardcoded values.
- **Locale-agnostic** — every text token is a `LocalizedStringKey`. Supports RTL out of the box.
- **Accessibility-first** — every component respects `accessibilityReduceTransparency` and `accessibilityReduceMotion`.
- **Liquid Glass native** — built on Apple's `GlassEffectContainer`, `glassEffect()`, and `GlassEffectTransition` APIs. iOS/macOS/tvOS/watchOS 26+ only.

## Topics

### Getting started
- <doc:GettingStarted>

### Theming
- <doc:Theming>

### Using templates
- <doc:BuildingTemplates>

### Extending the framework
- <doc:CreatingComponents>

### Core — Theme system
- ``LGThemeProtocol``
- ``LGColorTokens``
- ``LGTypographyTokens``
- ``LGSpacing``
- ``LGShape``

### Core — Animations
- ``LGAnimations``
- ``LGTransitions``

### Atoms
- ``LGButton``
- ``LGIconButton``
- ``LGAvatar``
- ``LGTextField``
- ``LGBadge``
- ``LGTag``
- ``LGProgressBar``
- ``LGProgressRing``
- ``LGStatLabel``

### Molecules
- ``LGCard``
- ``LGListRow``
- ``LGSearchBar``
- ``LGToast``
- ``LGBanner``
- ``LGToolbarGroup``
- ``LGTransactionRow``
- ``LGScoreRow``
- ``LGProductRow``
- ``LGLessonRow``
- ``LGLeagueRow``

### Organisms
- ``LGTabScaffold``
- ``LGBottomSheet``
- ``LGModal``
- ``LGSplitLayout``
- ``LGHeroDetail``

### Templates — Banking
- ``LGBankingDashboardView``
- ``LGBankingDashboardContent``
- ``LGTransactionListView``
- ``LGAccountDetailView``
- ``LGTransferView``

### Templates — Learning
- ``LGCourseHomeView``
- ``LGLessonView``
- ``LGProgressDashboardView``
- ``LGQuizView``

### Templates — Gaming
- ``LGGameHomeView``
- ``LGLeaderboardView``
- ``LGAchievementsView``

### Templates — Sports
- ``LGLeagueStandingsView``
- ``LGMatchDetailView``
- ``LGTeamProfileView``
- ``LGLiveScoreView``

### Templates — Betting
- ``LGEventsListView``
- ``LGBetSlipView``
- ``LGBetAccountView``

### Templates — Insurance
- ``LGPolicyOverviewView``
- ``LGClaimFormView``
- ``LGCoverageView``

### Templates — Shopping
- ``LGProductCatalogView``
- ``LGProductDetailView``
- ``LGCartView``
- ``LGCheckoutView``

### Templates — Library
- ``LGBookCatalogView``
- ``LGBookDetailView``
- ``LGReaderView``

### Templates — Code
- ``LGRepoListView``
- ``LGFileBrowserView``
- ``LGIssueListView``

### Templates — News
- ``LGNewsFeedView``
- ``LGArticleReaderView``

### Templates — Auth
- ``LGOnboardingView``
- ``LGLoginView``
- ``LGSignupView``

### Templates — Settings
- ``LGProfileView``
- ``LGSettingsView``
