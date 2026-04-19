# ADR-006: Localización via String Catalogs + soporte RTL nativo
<!-- ADR-006 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
El framework se usa en apps para mercados globales. Los textos del framework (labels de accesibilidad, placeholders, estados vacíos) deben ser localizables y el layout debe funcionar en idiomas RTL (árabe, hebreo, persa, etc.).

## Decisión

### Localización
- Todos los textos usan `LocalizedStringKey` o `String(localized: "key", bundle: .module)`.
- El String Catalog vive en `LiquidGlass/Core/Localization/LiquidGlass.xcstrings`.
- `bundle: .module` asegura que Xcode busca los strings en el bundle del framework, no en el app host.
- Los parámetros de texto públicos en los componentes son `LocalizedStringKey`, no `String`.
- Strings de ejemplo:
  ```
  "lg.button.close"       → "Close" / "Cerrar" / "إغلاق"
  "lg.search.placeholder" → "Search" / "Buscar" / "بحث"
  "lg.badge.new"          → "New" / "Nuevo" / "جديد"
  ```

### RTL
- **Nunca** usar `.environment(\.layoutDirection, .leftToRight)` para forzar LTR.
- Usar `HStack` y `leading`/`trailing` en vez de `left`/`right`.
- Los iconos direccionales (flechas) usan `.flipsForRightToLeftLayoutDirection(true)`.
- Las animaciones de slide usan `.leading`/`.trailing`, no `.left`/`.right`.

## Consecuencias
- El framework no provee traducciones — provee las keys. El consumer puede añadir traducciones al bundle del framework o sobreescribir los textos con sus propios `LocalizedStringKey`.
- Si un consumer pasa un texto como `LocalizedStringKey`, el sistema usa las traducciones del bundle del app host automáticamente.

## Alternativas consideradas
- **Strings hardcodeados en inglés**: no globalmente utilizables.
- **Archivos .strings separados por idioma**: el String Catalog (.xcstrings) es el estándar moderno de Apple y soporta pluralización, variaciones por dispositivo, etc.
