# 📁 Estructura de Carpetas – NeuralFlow (Android · Kotlin · Room)

Esta estructura está pensada para:

* Android (Kotlin)
* Arquitectura limpia (Clean Architecture)
* Room como base de datos local
* App de **tareas con recurrencia**
* Escalable pero clara (sin sobre‑arquitectura)

Paquete base:

```
com.neuralnet.neuralflow
```

---

## 🌳 Estructura General

```
com.neuralnet.neuralflow
│
├── data
│   ├── local
│   │   ├── database
│   │   │   └── NeuralFlowDatabase.kt
│   │   │
│   │   ├── dao
│   │   │   ├── TaskDao.kt
│   │   │   ├── TaskRecurrenceDao.kt
│   │   │   ├── TaskOccurrenceDao.kt
│   │   │   └── TaskHistoryDao.kt
│   │   │
│   │   └── entity
│   │       ├── TaskEntity.kt
│   │       ├── TaskRecurrenceEntity.kt
│   │       ├── TaskOccurrenceEntity.kt
│   │       └── TaskHistoryEntity.kt
│   │
│   ├── repository
│   │   └── TaskRepositoryImpl.kt
│   │
│   └── service
│       └── OccurrenceGenerator.kt
│
├── domain
│   ├── model
│   │   ├── Task.kt
│   │   ├── TaskRecurrence.kt
│   │   ├── TaskOccurrence.kt
│   │   └── TaskHistory.kt
│   │
│   ├── repository
│   │   └── TaskRepository.kt
│   │
│   └── usecase
│       ├── CreateTaskUseCase.kt
│       ├── CompleteOccurrenceUseCase.kt
│       ├── SkipOccurrenceUseCase.kt
│       ├── MoveOccurrenceUseCase.kt
│       ├── DisableTaskUseCase.kt
│       ├── EnableTaskUseCase.kt
│       └── DeleteTaskUseCase.kt
│
├── ui
│   ├── navigation
│   │   └── NavGraph.kt
│   │
│   ├── screens
│   │   ├── home
│   │   │   ├── HomeScreen.kt
│   │   │   ├── HomeViewModel.kt
│   │   │   └── HomeUiState.kt
│   │   │
│   │   ├── task_detail
│   │   │   ├── TaskDetailScreen.kt
│   │   │   ├── TaskDetailViewModel.kt
│   │   │   └── TaskDetailUiState.kt
│   │   │
│   │   ├── task_form
│   │   │   ├── TaskFormScreen.kt
│   │   │   ├── TaskFormViewModel.kt
│   │   │   └── TaskFormUiState.kt
│   │   │
│   │   ├── history
│   │   │   ├── TaskHistoryScreen.kt
│   │   │   └── TaskHistoryViewModel.kt
│   │   │
│   │   ├── settings
│   │   │   ├── SettingsScreen.kt
│   │   │   └── SettingsViewModel.kt
│   │   │
│   │   └── debug
│   │       └── DebugScreen.kt
│   │
│   └── theme
│       ├── Color.kt
│       ├── Theme.kt
│       └── Typography.kt
│
├── util
│   ├── DateUtils.kt
│   ├── RecurrenceCalculator.kt
│   └── Constants.kt
│
└── MainActivity.kt
```

---

## 🧠 ¿POR QUÉ ESTA ESTRUCTURA?

### ✅ Separación clara de responsabilidades

| Capa       | Responsabilidad                                 |
| ---------- | ----------------------------------------------- |
| **data**   | Room, DAOs, implementación real de repositorios |
| **domain** | Lógica de negocio pura (no Android)             |
| **ui**     | Pantallas, estados, navegación                  |
| **util**   | Helpers reutilizables                           |

---

## 🗄️ DATA

### `data/local/entity`

Clases **Room @Entity**, 1:1 con la base de datos:

* TaskEntity
* TaskRecurrenceEntity
* TaskOccurrenceEntity
* TaskHistoryEntity

👉 Aquí NO hay lógica, solo estructura.

### `data/local/dao`

Acceso a datos:

* Consultas por fecha
* Actualización de status
* Historial

### `data/service`

Lógica técnica que **no es UI ni dominio**:

* Generar occurrences
* Crear occurrences futuras
* Regenerar cuando se reactiva una tarea

---

## 🧩 DOMAIN (el corazón)

### `domain/model`

Modelos limpios, sin Room, sin Android:

```kotlin
data class Task(
    val id: Int,
    val title: String,
    val priority: Priority,
    val isActive: Boolean
)
```

### `domain/usecase`

Cada acción importante es un caso de uso:

* Crear tarea
* Completar occurrence
* Saltar occurrence
* Mover occurrence
* Deshabilitar / habilitar tarea

👉 Aquí vive la **lógica real del flujo**.

---

## 🎨 UI

### `ui/screens`

Organizado por **feature**, no por tipo:

```
home/
task_detail/
task_form/
history/
settings/
```

Cada screen tiene:

* Screen (Compose)
* ViewModel
* UiState

### `ui/navigation`

Un solo punto de navegación:

* rutas
* argumentos

---

## 🧰 UTIL

Funciones comunes:

* Fechas
* Cálculo de recurrencias
* Constantes (status, actions)

---

## 🔥 CONCLUSIÓN

Tu estructura **original era buena**, esta es una versión:

* Más clara
* Más escalable
* Muy alineada con Clean Architecture

Si quieres, el siguiente paso puede ser:

* 🧪 ejemplos reales de un UseCase
* 📱 ViewModel + flujo completo
* 🧭 Navigation con argumentos

Dime cuál seguimos 😉
