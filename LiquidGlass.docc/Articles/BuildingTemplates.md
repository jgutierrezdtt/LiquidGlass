# Building with Templates

Use domain screen templates to quickly ship full screens with Liquid Glass design.

## Overview

Each template in LiquidGlass follows the same pattern:

1. A **content protocol** (`LGXContent`) — defines what data and view slots you provide.
2. A **generic view** (`LGXView<Content>`) — implements the full screen layout.
3. A **preview content** struct — shows you a working example.

You implement the protocol, pass it to the view, and the screen is ready.

## Anatomy of a template

```swift
// What you implement
public protocol LGBankingDashboardContent {
    associatedtype HeroCardView: View
    var accountName: LocalizedStringKey { get }
    var balanceAmount: Decimal { get }
    var currencyCode: String { get }
    var transactions: [LGTransactionItem] { get }
    @ViewBuilder var heroCard: HeroCardView { get }
}

// What the framework provides
public struct LGBankingDashboardView<Content: LGBankingDashboardContent>: View { … }
```

## Using the default layout

The quickest path — provide data, let the template handle the visuals:

```swift
struct QuickDashboard: LGBankingDashboardContent {
    var accountName: LocalizedStringKey { "Current Account" }
    var balanceAmount: Decimal { 3_200.00 }
    var currencyCode: String { "EUR" }
    var transactions: [LGTransactionItem] { [] }
    @ViewBuilder var heroCard: some View { EmptyView() }
}

// Somewhere in your SwiftUI hierarchy:
LGBankingDashboardView(content: QuickDashboard())
```

## Replacing a view slot

Inject your own custom view into a `@ViewBuilder` slot:

```swift
struct MyDashboard: LGBankingDashboardContent {
    @ViewBuilder var heroCard: some View {
        // Fully custom card — your design, your data
        ZStack {
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            VStack(alignment: .leading) {
                Text("Premium Account").font(.headline).foregroundStyle(.white)
                Spacer()
                Text("€ 9,999.00").font(.largeTitle.bold()).foregroundStyle(.white)
            }
            .padding(24)
        }
        .frame(height: 200)
    }
    // … other required properties
}
```

## Available templates by domain

| Domain | Views |
|---|---|
| Banking | `LGBankingDashboardView`, `LGTransactionListView`, `LGAccountDetailView`, `LGTransferView` |
| Learning | `LGCourseHomeView`, `LGLessonView`, `LGProgressDashboardView`, `LGQuizView` |
| Gaming | `LGGameHomeView`, `LGLeaderboardView`, `LGAchievementsView` |
| Sports | `LGLeagueStandingsView`, `LGMatchDetailView`, `LGTeamProfileView`, `LGLiveScoreView` |
| Betting | `LGEventsListView`, `LGBetSlipView`, `LGBetAccountView` |
| Insurance | `LGPolicyOverviewView`, `LGClaimFormView`, `LGCoverageView` |
| Shopping | `LGProductCatalogView`, `LGProductDetailView`, `LGCartView`, `LGCheckoutView` |
| Library | `LGBookCatalogView`, `LGBookDetailView`, `LGReaderView` |
| Code | `LGRepoListView`, `LGFileBrowserView`, `LGIssueListView` |
| News | `LGNewsFeedView`, `LGArticleReaderView` |
| Auth | `LGOnboardingView`, `LGLoginView`, `LGSignupView` |
| Settings | `LGProfileView`, `LGSettingsView` |

## Combining templates with navigation

Templates compose naturally into `LGTabScaffold`:

```swift
struct AppRoot: View {
    var body: some View {
        LGTabScaffold {
            Tab("Home", systemImage: "house.fill") {
                LGBankingDashboardView(content: MyDashboard())
            }
            Tab("Transactions", systemImage: "list.bullet.rectangle") {
                LGTransactionListView(content: MyTransactionList())
            }
            Tab(role: .search) {
                LGSearchView()
            }
        }
    }
}
```
