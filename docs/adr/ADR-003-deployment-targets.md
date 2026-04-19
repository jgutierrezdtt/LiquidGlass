# ADR-003: Deployment targets exclusivamente 26+
<!-- ADR-003 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
Liquid Glass es una API introducida en iOS 26 / macOS 26 (Tahoe) / tvOS 26 / watchOS 12. El framework se construye sobre estas APIs como primitivas fundamentales — no son "nice to have", son la razón de ser de la librería.

## Decisión
Los deployment targets mínimos son:
- **iOS 26.0** / **iPadOS 26.0**
- **macOS 26.0** (Tahoe)
- **tvOS 26.0**
- **watchOS 12.0**

No se añaden `#available` guards para APIs de Liquid Glass. No se proveen fallbacks para versiones anteriores.

## Consecuencias
- El código es más limpio — sin ramas condicionales de versión.
- Los consumers deben tener el mismo deployment target mínimo para usar la librería.
- Si un consumer necesita soportar iOS 17/18, debe usar una versión diferente del framework o no usar LiquidGlass en esos targets.

## Alternativas consideradas
- **Soporte iOS 17/18 con fallbacks**: añadiría complejidad masiva (dos implementaciones de cada componente) y diluiría la propuesta de valor del framework.
- **Solo iOS/macOS, sin tvOS/watchOS**: descartado porque Liquid Glass está disponible en todas las plataformas Apple 26+.
