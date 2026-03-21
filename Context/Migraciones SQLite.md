# Migraciones SQLite - NeuralFlow

Este proyecto ya ejecuta migraciones de forma automatica al iniciar la app.

## Estado actual

- Version actual de esquema: `1`
- Archivo de migraciones: `lib/core/database/migrations.dart`
- Inicializacion DB: `lib/core/database/database_helper.dart`
- Arranque e inyeccion: `lib/main.dart`

## Como ejecutar migraciones

1. Instalar dependencias:

```bash
flutter pub get
```

2. Ejecutar la app:

```bash
flutter run
```

Al abrir la app, se inicializa `DatabaseHelper` y `openDatabase(...)` aplica:

- `onCreate` si la DB no existe
- `onUpgrade` si subes la version

## Como crear una nueva migracion

1. Incrementa `AppMigrations.currentVersion` en `lib/core/database/migrations.dart`.
2. Agrega un nuevo `case` en `_runMigration(db, version)`.
3. Ejecuta nuevamente:

```bash
flutter run
```

SQLite aplicara las migraciones pendientes desde la version anterior hasta la nueva.

## Reset de base de datos (solo desarrollo)

Si necesitas reprobar migraciones desde cero:

1. Llama temporalmente:

```dart
await DatabaseHelper.instance.deleteDatabaseFile();
```

2. Reinicia la app con `flutter run`.

Esto elimina la DB local y vuelve a ejecutar `onCreate` + migraciones.

## Estructura creada por la v1

- Tabla `tasks`
- Tabla `task_logs`
- `UNIQUE(task_id, date)` en `task_logs`
- `FOREIGN KEY ... ON DELETE CASCADE`
- Indices:
  - `idx_tasks_active`
  - `idx_task_logs_task_date`
  - `idx_task_logs_date`
