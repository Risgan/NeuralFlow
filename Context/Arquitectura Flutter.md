📁 1. Arquitectura Flutter + SQLite (estructura del proyecto)
# 📱 NeuralFlow - Arquitectura Flutter (SQLite, Local First)

## 🎯 Enfoque
Aplicación móvil local (offline-first) para gestión de tareas con recurrencia.

- Sin backend
- Sin autenticación
- Persistencia con SQLite
- Arquitectura limpia (modular y escalable)

---

## 🧱 Estructura de Carpetas


lib/
│
├── core/
│ ├── constants/
│ │ └── app_colors.dart
│ │ └── app_theme.dart
│ │
│ ├── utils/
│ │ └── date_utils.dart
│ │ └── recurrence_utils.dart
│ │
│ ├── database/
│ │ └── database_helper.dart
│ │ └── migrations.dart
│ │
│ └── widgets/
│ └── app_button.dart
│ └── app_card.dart
│ └── app_checkbox.dart
│
├── features/
│
│ ├── tasks/
│ │ ├── data/
│ │ │ ├── models/
│ │ │ │ └── task_model.dart
│ │ │ │ └── task_log_model.dart
│ │ │ │
│ │ │ ├── datasources/
│ │ │ │ └── task_local_datasource.dart
│ │ │ │
│ │ │ └── repositories/
│ │ │ └── task_repository_impl.dart
│ │ │
│ │ ├── domain/
│ │ │ ├── entities/
│ │ │ │ └── task.dart
│ │ │ │ └── task_log.dart
│ │ │ │
│ │ │ └── repositories/
│ │ │ └── task_repository.dart
│ │ │
│ │ ├── presentation/
│ │ │ ├── screens/
│ │ │ │ └── home_screen.dart
│ │ │ │ └── create_task_screen.dart
│ │ │ │ └── history_screen.dart
│ │ │ │ └── manage_tasks_screen.dart
│ │ │ │
│ │ │ ├── widgets/
│ │ │ │ └── task_card.dart
│ │ │ │ └── task_counter.dart
│ │ │ │ └── task_list.dart
│ │ │ │
│ │ │ └── providers/ (o bloc)
│ │ │ └── task_provider.dart
│ │
│
├── app.dart
└── main.dart


---

## 🗄️ Base de Datos (SQLite)

### Tabla: tasks
Definición de tareas (plantillas)


id INTEGER PRIMARY KEY
title TEXT
type TEXT (daily, weekly, monthly, once)
config TEXT (JSON)
time TEXT (nullable)
active INTEGER (0/1)
created_at TEXT


---

### Tabla: task_logs
Historial de ejecuciones


id INTEGER PRIMARY KEY
task_id INTEGER
date TEXT
completed_at TEXT


---

## ⚙️ Responsabilidades

### core/
- Reutilizable
- Sin lógica de negocio específica

### features/tasks
- Toda la lógica de tareas
- Separación en:
  - data → acceso a SQLite
  - domain → reglas del negocio
  - presentation → UI

---

## 🧠 Motor de Recurrencia

Ubicación:

core/utils/recurrence_utils.dart


Responsabilidad:
- Determinar si una tarea aplica para hoy
- Generar tareas del día dinámicamente

---

## 🔄 Flujo

1. App abre
2. Se consultan tareas activas
3. Se filtran según fecha (recurrencia)
4. Se cruzan con task_logs
5. Se renderiza:
   - Pendientes
   - Completadas

---

## 🎯 Beneficios

- Escalable (puedes agregar notificaciones luego)
- Testeable
- Separación clara
- Fácil mantenimiento