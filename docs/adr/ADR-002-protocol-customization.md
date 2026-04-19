# ADR-002: Protocolo + ViewBuilder slots como mecanismo de personalización
<!-- ADR-002 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
Las Templates deben ser "ready to use" pero también completamente editables. El consumer necesita poder reemplazar textos, imágenes, datos y secciones enteras sin tener que re-implementar toda la pantalla.

## Decisión
Cada Template expone dos artefactos públicos:

1. **Protocolo de contenido** (`LGXContent`) — define qué datos/vistas debe proveer el consumer:
   ```swift
   public protocol LGBankingDashboardContent {
       associatedtype BalanceView: View
       @ViewBuilder var balanceHero: BalanceView { get }
       var accountName: LocalizedStringKey { get }
       var transactions: [LGTransactionItem] { get }
   }
   ```

2. **Vista genérica** (`LGXView<Content: LGXContent>`) — implementa toda la UI; el consumer inyecta su implementación del protocolo:
   ```swift
   public struct LGBankingDashboardView<Content: LGBankingDashboardContent>: View {
       private let content: Content
       public init(content: Content) { self.content = content }
   }
   ```

Los `@ViewBuilder` en el protocolo permiten inyectar vistas completas como slots. Los datos simples (textos, listas) se pasan como propiedades del protocolo.

## Consecuencias
- **Sin `AnyView`** — mantenemos type-safety total y rendimiento óptimo de SwiftUI.
- El consumer no necesita acceder al código fuente para usar una Template.
- Si quiere modificar la estructura visual, puede copiar la implementación y adaptarla (código fuente accesible).
- Cada Template incluye una implementación preview (`LGXPreviewContent`) que sirve como ejemplo de uso.

## Alternativas consideradas
- **Subclassing**: incompatible con `struct` de SwiftUI.
- **Environment values como configuración**: útil para el tema, pero insuficiente para slots de vista completos.
- **AnyView**: evitado por pérdida de type safety y penalización de rendimiento en SwiftUI.
