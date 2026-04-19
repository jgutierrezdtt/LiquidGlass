# ADR-007: Accesibilidad como ciudadano de primera clase
<!-- ADR-007 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
Liquid Glass usa transparencia, animaciones de morf y blur intenso. Estos efectos pueden ser problemáticos para usuarios con sensibilidad al movimiento, baja visión, o que usen VoiceOver/Voice Control.

## Decisión
Accesibilidad es **obligatoria en cada componente**, no opcional. El checklist de un componente aprobado:

### 1. Etiquetas de accesibilidad
- Todo `Image(systemName:)` tiene `.accessibilityLabel(Text(LocalizedStringKey))`.
- Todo elemento interactivo tiene `.accessibilityHint(Text(LocalizedStringKey))`.
- Los valores dinámicos (balance, marcador, progreso) se expresan con `.accessibilityValue(Text(...))`.

### 2. Reduce Transparency
```swift
@Environment(\.accessibilityReduceTransparency) private var reduceTransparency

var background: some View {
    if reduceTransparency {
        RoundedRectangle(cornerRadius: LGShape.md.radius)
            .fill(theme.colors.surface.opacity(0.95))
    } else {
        RoundedRectangle(cornerRadius: LGShape.md.radius)
            .glassEffect(in: .rect(cornerRadius: LGShape.md.radius))
    }
}
```

### 3. Reduce Motion
```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

func toggle() {
    if reduceMotion {
        isExpanded.toggle()
    } else {
        withAnimation(LGAnimations.snappy) { isExpanded.toggle() }
    }
}
```

### 4. Dynamic Type
- Nunca `.font(.system(size: 14))`.
- Siempre `.font(theme.typography.body)` que internamente usa `.body` o `.custom(...).dynamicTypeSize(...)`.
- Los layouts usan `ViewThatFits` o `@ScaledMetric` cuando las dimensiones deben escalar.

### 5. VoiceOver grouping
- Los `LGCard` compuestos tienen `.accessibilityElement(children: .combine)` para leerlos como una unidad.
- Las listas usan `.accessibilityLabel` en el row completo.

## Consecuencias
- Añade ~5-10 líneas por componente, pero garantiza que el framework es usable para el 20%+ de usuarios con alguna necesidad de accesibilidad.
- Los Previews deben incluir una variante con `reduceTransparency: true` y `reduceMotion: true`.

## Herramienta de verificación
Xcode Accessibility Inspector + VoiceOver en Simulator para cada componente nuevo.
