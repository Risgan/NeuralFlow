# Prompt de Icono para la App (Sora / Nano Bana)

Este documento es para generar SOLO el icono de la app Neural Flow.

Objetivo:

- Obtener un icono limpio, profesional y escalable para usar en Android/iOS.

---

## Prompt Maestro (copiar tal cual)

Genera un icono de app para una aplicacion llamada "Neural Flow".

Requisitos obligatorios:

- Solo el icono, sin telefono, sin mockup, sin interfaz de app
- Composicion centrada y simetrica
- Estilo minimalista premium
- Forma principal: simbolo abstracto que combine "flujo" + "enfoque" + "progreso"
- Paleta: azul profundo, cian suave, acento blanco
- Contraste alto para verse bien en tamanos pequenos
- Sin texto, sin letras, sin palabras
- Fondo limpio
- Bordes suaves y acabados modernos
- Apariencia nativa para launcher icon

Entrega tecnica:

- 1024x1024 px
- PNG
- Alta nitidez
- Sin marca de agua
- Sin ruido visual

---

## Negative Prompt (muy importante)

No incluir:

- Smartphone
- Pantalla de app
- Mockup de dispositivo
- Personas, manos, dedos
- Texto o tipografia
- Logos de marcas reales
- Estilo cartoon infantil
- Exceso de detalles finos
- Sombras exageradas

---

## Variantes de estilo (elige una)

## Variante A: Geometrico moderno

Icono abstracto geometrico con trazos limpios, equilibrio visual y profundidad sutil. Paleta azul-cian, fondo oscuro elegante, look tecnologico premium.

## Variante B: Glow elegante

Icono minimal con brillo suave interno (glow), contraste alto y volumen discreto. Fondo simple para que el simbolo destaque en launcher.

## Variante C: Flat premium

Icono flat de alto contraste, sin efectos 3D fuertes, lineas claras y lectura excelente en tamano pequeno.

---

## Prompt Corto (fallback)

Crea SOLO un icono de app 1024x1024 para "Neural Flow", estilo minimalista premium, simbolo abstracto de flujo/progreso, colores azul profundo y cian, sin texto, sin smartphone, sin mockup, sin UI, alta nitidez, PNG.

---

## Flujo recomendado para obtener buen resultado

1. Genera 4-8 propuestas con el Prompt Maestro.
2. Elige 2 finalistas por legibilidad en tamano pequeno.
3. Pide una iteracion del mejor: "hazlo mas simple y con mas contraste".
4. Exporta 1024x1024.

---

## Como integrarlo en Flutter rapidamente (usando icono04.png)

1. Copia tu imagen al path de iconos:

```powershell
New-Item -ItemType Directory -Path .\assets\app_icon -Force | Out-Null
Copy-Item -Path .\Context\icono04.png -Destination .\assets\app_icon\icon.png -Force
```

2. En `pubspec.yaml` usa esta configuracion (clave correcta: `flutter_launcher_icons`):

```yaml
dev_dependencies:
	flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
	android: true
	ios: true
	image_path: assets/app_icon/icon.png
```

3. Genera los iconos:

```powershell
flutter pub get
dart run flutter_launcher_icons
```

4. Reinstala la app para ver el icono nuevo:

```powershell
adb uninstall com.example.neural_flow
flutter run
```
