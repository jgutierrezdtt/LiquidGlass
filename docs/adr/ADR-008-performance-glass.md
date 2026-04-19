# ADR-008: Reglas de performance para GlassEffectContainer
<!-- ADR-008 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
`GlassEffectContainer` es costoso de renderizar. Múltiples containers en pantalla o containers anidados degradan el rendimiento notablemente. Apple documenta esto explícitamente en "Optimize performance when using Liquid Glass effects".

## Decisión
Reglas **obligatorias** en todo el framework:

### Regla 1: Un container por sección lógica
Cada pantalla puede tener varios `GlassEffectContainer`, pero solo uno por sección lógica independiente. Ejemplo:
- ✅ Un container para la toolbar, otro para los cards del dashboard
- ❌ Un container por cada card individual

### Regla 2: Nunca anidar GlassEffectContainer
```swift
// ❌ PROHIBIDO
GlassEffectContainer {
    GlassEffectContainer { // nunca
        Text("hello").glassEffect()
    }
}

// ✅ CORRECTO
GlassEffectContainer {
    Text("hello").glassEffect()
    Text("world").glassEffect()
}
```

### Regla 3: Preferir glassEffectUnion sobre múltiples .glassEffect() independientes
Cuando varios elementos deben compartir una sola forma glass, usar `glassEffectUnion`:
```swift
// ✅ Mejor rendimiento cuando deben fundirse
ForEach(items) { item in
    ItemView(item)
        .glassEffect()
        .glassEffectUnion(id: "toolbar", namespace: ns)
}
```

### Regla 4: Aplicar .glassEffect() después de todos los modificadores visuales
```swift
// ✅ Correcto
Text("Hello")
    .font(theme.typography.headline)
    .padding(LGSpacing.md)
    .glassEffect() // último

// ❌ Incorrecto  
Text("Hello")
    .glassEffect() // antes del padding — el efecto no captura el padding
    .padding(LGSpacing.md)
```

### Regla 5: Máximo ~6-8 glass shapes activas simultáneamente en pantalla
Si una pantalla necesita más, combinar con `glassEffectUnion` o reconsiderar el diseño.

## Consecuencias
- Los code reviews deben verificar estas reglas explícitamente.
- En caso de duda sobre rendimiento, usar Instruments > Metal System Trace para medir.

## Referencias
- [Optimize performance when using Liquid Glass effects](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views#Optimize-performance-when-using-Liquid-Glass-effects)
- WWDC25: "Optimize SwiftUI performance with Instruments"
