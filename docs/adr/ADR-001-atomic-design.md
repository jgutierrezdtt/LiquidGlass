# ADR-001: Atomic Design como arquitectura de componentes
<!-- ADR-001 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
Necesitamos una estructura de carpetas y dependencias que escale a 60+ componentes reutilizables entre 12 dominios de plantillas distintos, sin que los componentes de nivel bajo dependan de los de nivel alto.

## Decisión
Adoptamos **Atomic Design** (Brad Frost) adaptado a SwiftUI:

```
Core/           → Sin dependencias externas. Base de todo.
Atoms/          → Dependen solo de Core.
Molecules/      → Dependen de Atoms + Core.
Organisms/      → Dependen de Molecules + Atoms + Core.
Templates/      → Dependen de Organisms + todo lo anterior.
Animations/     → Dependen solo de Core.
```

La regla de oro: **nunca importar hacia arriba**. Un Atom no conoce a una Molecule. Una Template no importa otra Template.

## Mapeo a SwiftUI
- **Atoms** = controles atómicos (LGButton, LGAvatar, LGTextField…)
- **Molecules** = composiciones de átomos con lógica de presentación (LGCard, LGListRow…)
- **Organisms** = layouts completos reutilizables (LGTabScaffold, LGSplitLayout…)
- **Templates** = pantallas por dominio con protocolo de contenido inyectable

## Consecuencias
- Los consumers solo necesitan importar `LiquidGlass` (umbrella) — no sub-módulos.
- Añadir un componente nuevo requiere decidir su capa antes de implementarlo.
- Tests unitarios por capa: los Atoms son los más fáciles de testear en aislamiento.

## Alternativas consideradas
- **Feature modules**: mayor granularidad, pero innecesariamente complejo para una librería privada de un solo framework.
- **Flat structure**: simple, pero no escala sin convenciones de naming muy rígidas.
