# Guia: Actualizar Icono en Flutter (cuando sigue saliendo el icono viejo)

Si cambiaste la imagen y solo hiciste:

```powershell
adb uninstall com.example.neural_flow
flutter run
```

es normal que siga saliendo el icono anterior, porque falta regenerar los recursos nativos del launcher.

---

## Regla clave

Cambiar el PNG NO actualiza automaticamente los `mipmap` de Android.
Siempre debes ejecutar `flutter_launcher_icons` despues de cambiar la imagen.

---

## Flujo correcto (100% recomendado)

## 1) Copia la nueva imagen

```powershell
New-Item -ItemType Directory -Path .\assets\app_icon -Force | Out-Null
Copy-Item -Path .\Context\icono04.png -Destination .\assets\app_icon\icon.png -Force
```

## 2) Verifica configuracion en `pubspec.yaml`

Debe existir esto:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/app_icon/icon.png
```

Nota: la clave correcta es `flutter_launcher_icons` (no `flutter_icons`).

## 3) Regenera iconos

```powershell
flutter pub get
dart run flutter_launcher_icons
```

Debes ver en consola algo como:

- `Successfully generated launcher icons`

## 4) Limpieza + reinstalacion

```powershell
flutter clean
adb uninstall com.example.neural_flow
flutter run
```

---

## Si aun sale el icono anterior

## 1) Verifica que el plugin realmente reescribio Android

Revisa que existan/actualicen estos archivos:

- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

Si no cambiaron, repite el paso 3.

## 2) Limpia cache del launcher del telefono

Algunos launchers cachean el icono aunque la app se reinstale.

Opciones:

- Quitar el acceso directo de pantalla de inicio y volver a agregarlo.
- Reiniciar el telefono.
- Cambiar temporalmente de launcher y volver.

## 3) Fuerza compilacion nueva

```powershell
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter run
```

---

## Comando rapido (todo en orden)

```powershell
Copy-Item -Path .\Context\icono04.png -Destination .\assets\app_icon\icon.png -Force
flutter pub get
dart run flutter_launcher_icons
flutter clean
adb uninstall com.example.neural_flow
flutter run
```

---

## Checklist final

- Imagen nueva en `assets/app_icon/icon.png`
- `pubspec.yaml` con `flutter_launcher_icons`
- Corriste `dart run flutter_launcher_icons`
- Corriste `flutter clean`
- Reinstalaste la app
- Si persiste: limpiaste cache del launcher
