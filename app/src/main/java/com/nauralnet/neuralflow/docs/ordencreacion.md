# 🛠️ Orden de Creación y Dependencias – NeuralFlow (Android · Kotlin · Room)

Este documento explica **en qué orden crear las cosas** y **qué depende de qué**, para que no te bloquees ni tengas errores circulares mientras construyes la app.

La idea es ir de **lo más básico y estable** a **lo más visible (UI)**.

---

## 🧱 FASE 0 – Proyecto Base

### 1️⃣ Crear el proyecto Android

* Empty Activity
* Kotlin
* Minimum SDK recomendado: **API 34+**
* Activar **Jetpack Compose**

👉 No escribas lógica todavía.

---

## 📦 FASE 1 – Dependencias (Gradle)

### 2️⃣ Dependencias base (app/build.gradle)

```gradle
// Compose
implementation(platform("androidx.compose:compose-bom:2024.02.00"))
implementation("androidx.compose.ui:ui")
implementation("androidx.compose.material3:material3")
implementation("androidx.activity:activity-compose")

// ViewModel
implementation("androidx.lifecycle:lifecycle-viewmodel-compose")
implementation("androidx.lifecycle:lifecycle-runtime-compose")

// Room
implementation("androidx.room:room-runtime:2.6.1")
kapt("androidx.room:room-compiler:2.6.1")
implementation("androidx.room:room-ktx:2.6.1")

// Coroutines
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")

// Navigation Compose
implementation("androidx.navigation:navigation-compose:2.7.7")
```

🔴 **Orden importante**: primero dependencias, luego código.

---

## 🗂️ FASE 2 – DATA (Base de datos primero)

### 3️⃣ Crear paquetes

```
data/local/entity
data/local/dao
data/local/database
```

### 4️⃣ Crear Entities (Room)

Orden recomendado:

1. `TaskEntity`
2. `TaskRecurrenceEntity`
3. `TaskOccurrenceEntity`
4. `TaskHistoryEntity`

👉 Solo campos y anotaciones Room.
👉 Nada de lógica.

---

### 5️⃣ Crear DAOs

Orden:

1. TaskDao
2. TaskRecurrenceDao
3. TaskOccurrenceDao
4. TaskHistoryDao

Cada DAO solo conoce **su entity**.

---

### 6️⃣ Crear la Database

```kotlin
@Database(
    entities = [
        TaskEntity::class,
        TaskRecurrenceEntity::class,
        TaskOccurrenceEntity::class,
        TaskHistoryEntity::class
    ],
    version = 1
)
abstract class NeuralFlowDatabase : RoomDatabase() {
    abstract fun taskDao(): TaskDao
    abstract fun taskOccurrenceDao(): TaskOccurrenceDao
}
```

👉 En este punto **Room ya compila**.

---

## 🧠 FASE 3 – DOMAIN (lógica pura)

### 7️⃣ Crear modelos de dominio

```
domain/model
```

* Task
* TaskRecurrence
* TaskOccurrence
* TaskHistory

🚫 No Room
🚫 No Android

---

### 8️⃣ Crear contratos de repositorio

```
domain/repository/TaskRepository.kt
```

Aquí defines lo que la app **necesita hacer**, no cómo.

---

### 9️⃣ Crear UseCases

Orden sugerido:

1. CreateTaskUseCase
2. GenerateOccurrencesUseCase
3. CompleteOccurrenceUseCase
4. SkipOccurrenceUseCase
5. MoveOccurrenceUseCase
6. DisableTaskUseCase
7. EnableTaskUseCase
8. DeleteTaskUseCase

👉 Cada UseCase = una acción del usuario.

---

## 🔌 FASE 4 – DATA (implementación real)

### 🔟 Implementar Repository

```
data/repository/TaskRepositoryImpl.kt
```

Este:

* Implementa `TaskRepository`
* Usa DAOs
* Convierte Entity ↔ Domain

---

### 1️⃣1️⃣ Servicios técnicos

```
data/service/OccurrenceGenerator.kt
```

Aquí va:

* Cálculo de recurrencias
* Generación de occurrences
* Regeneración al reactivar tareas

---

## 🎨 FASE 5 – UI

### 1️⃣2️⃣ Navigation

```
ui/navigation/NavGraph.kt
```

Define rutas antes de las pantallas.

---

### 1️⃣3️⃣ Screens (por feature)

Orden recomendado:

1. Home
2. TaskForm
3. TaskDetail
4. History
5. Settings

Cada screen:

* UiState
* ViewModel
* Screen (Compose)

---

## 🔄 FASE 6 – Integración final

### 1️⃣4️⃣ Conectar ViewModel → UseCases

ViewModel:

* No accede a DAOs
* Solo llama UseCases

---

### 1️⃣5️⃣ MainActivity

```kotlin
setContent {
    NeuralFlowTheme {
        NavGraph()
    }
}
```

---

## 🔗 DEPENDENCIAS ENTRE CAPAS

```
UI → ViewModel → UseCase → Repository (domain)
                         ↓
                     RepositoryImpl
                         ↓
                        DAO → Room
```

🚫 Nunca al revés.

---

## ✅ REGLA DE ORO

> **Si algo no compila, es porque estás yendo en el orden incorrecto**.

Siempre:

1. Modelo
2. Contrato
3. Implementación
4. UI

---

## 🧭 ¿Siguiente paso?

Podemos hacer:

* 📌 checklist día a día
* 🧪 tests por capa
* 🧩 ejemplo completo: botón → DB → UI

Dime y seguimos 🔥
