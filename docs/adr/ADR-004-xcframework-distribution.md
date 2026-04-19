# ADR-004: Distribución como XCFramework binario
<!-- ADR-004 | Status: Accepted | Date: 2026-04-19 -->

## Contexto
La librería es privada. Necesitamos una forma de distribuirla que permita mantener el código fuente accesible para el dueño, pero también generar un binario listo para embeber en proyectos consumidores sin necesidad de Xcode open.

## Decisión
Distribuimos como **XCFramework** generado mediante `Scripts/build-xcframework.sh`.

El script archiva los siguientes slices:
- `iphoneos` + `iphonesimulator`
- `macosx`
- `appletvos` + `appletvsimulator`
- `watchos` + `watchsimulator`

Y los combina con `xcodebuild -create-xcframework` en `LiquidGlass.xcframework`.

El código fuente permanece accesible en este repositorio. El XCFramework se genera a demanda.

## Cómo compilar
```bash
cd /path/to/LiquidGlass
chmod +x Scripts/build-xcframework.sh
./Scripts/build-xcframework.sh
```
El artefacto final aparece en `build/LiquidGlass.xcframework`.

## Cómo consumir
En el proyecto destino:
1. Drag & drop `LiquidGlass.xcframework` en "Frameworks, Libraries, and Embedded Content".
2. Configurar como "Embed & Sign" para apps, "Do Not Embed" para frameworks que lo re-distribuyen.
3. `import LiquidGlass` en cualquier archivo Swift.

## Alternativas consideradas
- **Swift Package Manager (SPM)**: ideal para open source, pero requiere git repo con acceso o un registry privado. Añade complejidad de gestión de versiones.
- **CocoaPods**: obsoleto para proyectos nuevos en Apple ecosystem.
- **Source-only (no compilado)**: sería más simple, pero no protege la IP en distribuciones externas.
