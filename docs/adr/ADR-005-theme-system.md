# ADR-005: Sistema de tema agnóstico via EnvironmentKey
<!-- ADR-005 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
Los componentes deben funcionar en apps de cualquier industria (banking, gaming, sports, etc.) con cualquier paleta de colores, tipografía y espaciado. Los colores y fuentes hardcodeados están prohibidos.

## Decisión
Implementamos un sistema de tema basado en:

1. **Protocolo `LGThemeProtocol`** — define los tokens semánticos:
   ```swift
   public protocol LGThemeProtocol {
       var colors: LGColorTokens { get }
       var typography: LGTypographyTokens { get }
   }
   ```

2. **EnvironmentKey `LGThemeKey`** — inyecta el tema en el árbol de vistas:
   ```swift
   extension EnvironmentValues {
       public var lgTheme: any LGThemeProtocol { get set }
   }
   ```

3. **Tema por defecto `LGDefaultTheme`** — usa colores del sistema (`.primary`, `.secondary`, etc.) y tipografía dinámica de SwiftUI para funcionar sin configuración.

4. **Modifier `.lgTheme(_:)`** — el consumer inyecta su tema custom en la raíz de su app:
   ```swift
   ContentView()
       .lgTheme(MyBankingTheme())
   ```

## Tokens disponibles
| Categoría | Tokens |
|---|---|
| Colores | `primary`, `secondary`, `surface`, `accent`, `destructive`, `onSurface`, `onPrimary` |
| Tipografía | `display`, `headline`, `title`, `body`, `caption`, `label` |
| Espaciado | `LGSpacing.xs/sm/md/lg/xl/xxl` (constantes, no parte del tema) |
| Formas | `LGShape.capsule/.rounded(.sm/.md/.lg)` (constantes) |

## Consecuencias
- Los componentes nunca tienen colores hardcodeados.
- El consumer puede crear su propio tema implementando `LGThemeProtocol`.
- El espaciado y las formas son constantes del framework (no configurables) para mantener coherencia de diseño.

## Alternativas consideradas
- **Variables globales / singletons**: descartados por ser incompatibles con previews en paralelo y difíciles de testear.
- **Parámetros en cada init**: verboso y rompe la composición de vistas.
- **EnvironmentObject**: requiere `ObservableObject` y hace el tema mutable innecesariamente.
