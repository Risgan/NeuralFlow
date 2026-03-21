# Guia Operativa: APK y Base de Datos (Android)

Este documento explica 3 cosas:

1. Como generar el APK para instalar en Android
2. Como extraer y ver la base de datos SQLite del celular (USB + Developer mode)
3. Como restaurar la base de datos de forma deliberada y segura

Proyecto: `neural_flow`
App ID (package): `com.example.neural_flow`
DB SQLite: `neural_flow.db`

---

## 1) Generar APK para instalar en Android

### Requisitos

- Flutter instalado y en PATH
- Android SDK/Platform Tools instalados
- Dispositivo Android con USB debugging habilitado

### Paso a paso (PowerShell en la raiz del proyecto)

```powershell
flutter clean
flutter pub get
flutter build apk --release
```

APK generado en:

- `build\app\outputs\flutter-apk\app-release.apk`

### Instalar APK por ADB

```powershell
adb devices
adb install -r .\build\app\outputs\flutter-apk\app-release.apk
```

Notas:

- `-r` reinstala conservando datos de la app cuando sea posible.
- Si quieres validar que se instaló: `adb shell pm list packages | findstr neural_flow`

### (Opcional) APK por arquitectura (mas liviano)

```powershell
flutter build apk --release --split-per-abi
```

Genera varios APK en:

- `build\app\outputs\flutter-apk\`

---

## 2) Ver la BD que esta en el celular (USB)

### Objetivo

Sacar una copia local de la BD para abrirla en DBeaver.

Ruta interna en Android (sandbox app):

- `/data/data/com.example.neural_flow/databases/neural_flow.db`

### Paso a paso

1. Conecta el celular por USB y verifica conexion:

```powershell
adb devices
```

2. Fuerza cierre de la app para evitar lock por WAL:

```powershell
adb shell am force-stop com.example.neural_flow
```

3. Verifica que exista la BD:

```powershell
adb shell run-as com.example.neural_flow ls -la databases
```

4. Extrae la BD principal al proyecto:

```powershell
adb exec-out run-as com.example.neural_flow cat databases/neural_flow.db > .\neural_flow.db
```

5. (Recomendado) Extrae WAL y SHM si existen:

```powershell
adb exec-out run-as com.example.neural_flow cat databases/neural_flow.db-wal > .\neural_flow.db-wal
adb exec-out run-as com.example.neural_flow cat databases/neural_flow.db-shm > .\neural_flow.db-shm
```

Si alguno no existe, ignora ese error.

### Abrir en DBeaver

1. `Database` -> `New Database Connection`
2. Selecciona `SQLite`
3. En `Database file`, apunta a:
   - `C:\Proyectos\NeuralNet\neural_flow\neural_flow.db`
4. `Test Connection` -> `Finish`

### Queries utiles

```sql
-- Ver tablas
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;

-- Ver tareas
SELECT id, title, type, active, created_at, updated_at
FROM tasks
ORDER BY id DESC;

-- Ver historial de completadas
SELECT id, task_id, date, status, completed_at
FROM task_logs
ORDER BY date DESC, id DESC;
```

---

## 3) Restaurar la BD de forma deliberada

Hay 2 estrategias seguras. Usa la que te convenga.

## Opcion A: Restaurar desde backup exacto (reemplazo total)

Usa esto cuando quieras volver a un estado conocido de la BD.

### Preparar backup local

Asegurate de tener archivo de respaldo local, por ejemplo:

- `C:\Backups\neural_flow_2026-03-20.db`

### Pasos de restauracion

1. Cierra la app:

```powershell
adb shell am force-stop com.example.neural_flow
```

2. Sube el backup al dispositivo (zona temporal):

```powershell
adb push C:\Backups\neural_flow_2026-03-20.db /data/local/tmp/neural_flow.db
```

3. Copia el backup al sandbox de la app y corrige permisos:

```powershell
adb shell run-as com.example.neural_flow sh -c "cp /data/local/tmp/neural_flow.db databases/neural_flow.db"
adb shell run-as com.example.neural_flow sh -c "rm -f databases/neural_flow.db-wal databases/neural_flow.db-shm"
```

4. Abre la app de nuevo y valida datos.

### Verificacion rapida post-restore

```powershell
adb shell run-as com.example.neural_flow ls -la databases
```

Luego extrae otra vez la BD (seccion 2) y valida con DBeaver.

## Opcion B: Reset intencional (vaciar y regenerar)

Usa esto en pruebas, cuando quieres empezar limpio.

Formas comunes:

- Desinstalar e instalar de nuevo:

```powershell
adb uninstall com.example.neural_flow
adb install .\build\app\outputs\flutter-apk\app-release.apk
```

- O usar una accion de desarrollo dentro de la app (si existe) para borrar BD y recrearla.

---

## Buenas practicas para no corromper datos

- Siempre cerrar la app antes de extraer/restaurar.
- Si existe WAL/SHM, respalda tambien esos archivos.
- No editar la BD del telefono en caliente.
- Guardar backups con fecha en nombre:
  - `neural_flow_YYYY-MM-DD_HH-mm.db`
- Validar tablas clave despues de restaurar: `tasks`, `task_logs`.

---

## Troubleshooting rapido

- `run-as: package not debuggable`
  - Instala build debug en el dispositivo o valida configuracion de build.

- `adb: device unauthorized`
  - Reautoriza USB debugging en el celular.

- Error al copiar a `databases/`
  - Revisa package id correcto y que la app haya abierto al menos una vez para crear carpeta BD.

- DBeaver no refleja cambios recientes
  - Repite extraccion de BD (el archivo local no se actualiza solo).
