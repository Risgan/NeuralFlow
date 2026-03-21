# Guia: Splash Screen Bonito en Flutter

Esta guia te muestra una forma profesional y simple de tener un splash bonito:

1. Splash nativo (Android/iOS) rapido con logo
2. Splash animado dentro de Flutter (opcional, recomendado)

Resultado:

- La app abre con buena presencia visual
- Se evita pantalla blanca al iniciar
- Se siente premium en Android e iOS

---

## Parte 1: Splash nativo con flutter_native_splash

## 1) Agrega dependencia de desarrollo

En pubspec.yaml:

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.1
```

Luego:

```powershell
flutter pub get
```

## 2) Prepara assets

Crea estos archivos (ejemplo):

- assets/splash/splash_logo.png (recomendado 1024x1024, fondo transparente)
- assets/splash/splash_logo_dark.png (opcional)

Tip:

- Usa un logo limpio y centrado
- Evita textos pequenos dentro del logo

## 3) Configura flutter_native_splash

En pubspec.yaml agrega:

```yaml
flutter_native_splash:
  color: "#0B1220"
  image: assets/splash/splash_logo.png
  color_dark: "#070B14"
  image_dark: assets/splash/splash_logo_dark.png

  android_12:
    color: "#0B1220"
    image: assets/splash/splash_logo.png
    color_dark: "#070B14"
    image_dark: assets/splash/splash_logo_dark.png

  web: false
```

## 4) Genera el splash nativo

```powershell
dart run flutter_native_splash:create
```

Para revertir si algo sale mal:

```powershell
dart run flutter_native_splash:remove
```

---

## Parte 2: Splash animado en Flutter (recomendado)

El splash nativo se ve solo unos instantes. Para un look bonito, agrega una pantalla inicial animada.

## 1) Crea pantalla splash animada

Archivo sugerido:

- lib/features/splash/presentation/splash_screen.dart

Ejemplo base:

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1220), Color(0xFF0F1B33), Color(0xFF132748)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/splash/splash_logo.png', width: 120),
                  const SizedBox(height: 18),
                  const Text(
                    'Neural Flow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enfocate en lo importante',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## 2) Registra la ruta y arranque

En tu navegacion, usa esta pantalla como entrada inicial y luego redirige a Home.

Opciones:

- `home: const SplashScreen()`
- o `initialRoute: '/splash'`

## 3) Paso adicional: usar animacion de logo (video 2s)

Si tienes un video de 2 segundos, SI se puede usar, pero no en el splash nativo puro.

Regla importante:

- `flutter_native_splash` solo muestra imagen estatica (no reproduce MP4/GIF).
- Para video/animacion, se hace en la pantalla splash de Flutter (la de la Parte 2).

Formato recomendado:

- Mejor opcion: MP4 (H.264), corto, sin audio, 720p o 1080p.
- Alternativa: Lottie (`.json`) si tienes animacion vectorial.
- GIF funciona, pero suele verse peor y consumir mas recursos.

### Implementacion con MP4

1. Agrega dependencia:

```yaml
dependencies:
  video_player: ^2.10.0
```

2. Guarda el video en:

- `assets/splash/logo_intro.mp4`

3. Declara assets en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/splash/logo_intro.mp4
    - assets/splash/splash_logo.png
```

4. Reemplaza el contenido central de `SplashScreen` por un reproductor:

```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash/logo_intro.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });

    _controller.setLooping(false);

    _controller.addListener(() {
      if (!mounted || !_controller.value.isInitialized) return;
      final v = _controller.value;
      final ended = v.position >= v.duration && !v.isPlaying;
      if (ended) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0B1220),
        alignment: Alignment.center,
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Image.asset('assets/splash/splash_logo.png', width: 120),
      ),
    );
  }
}
```

Tip:

- Exporta el video sin audio y con fondo acorde al splash para que no se note corte.
- Duracion recomendada: 1.5s a 2.2s.
- Mantén el splash nativo como "puente" mientras Flutter inicializa.

---

## Recomendaciones de diseno (para que se vea bonito)

- Duracion ideal: 1.2s a 2.0s
- Animaciones simples: fade + scale (evita saturar)
- Colores: 2 o 3 tonos maximo
- Texto minimo: nombre + tagline corto
- Mantener consistencia con paleta de la app

---

## Checklist rapido

- Dependencia instalada
- Config en pubspec correcta
- Assets en rutas correctas
- Splash nativo generado
- Splash animado conectado al flujo
- Prueba en dispositivo real

---

## Comandos utiles de prueba

```powershell
flutter clean
flutter pub get
dart run flutter_native_splash:create
flutter run
```

Si no se refleja en Android:

```powershell
flutter clean
adb uninstall com.example.neural_flow
flutter run
```

---

## Errores comunes

- Logo no aparece:
  - Ruta de asset mal escrita
  - Asset no declarado en `flutter.assets`

- Splash viejo persiste:
  - No corriste `flutter clean`
  - App no se reinstalo en dispositivo

- En Android 12 se ve distinto:
  - Falta bloque `android_12` en config

---

## Siguiente mejora opcional

Si quieres una experiencia aun mas premium:

- Añadir Lottie sutil en splash animado
- Precargar datos criticos durante splash
- Navegar a onboarding o home segun estado del usuario
