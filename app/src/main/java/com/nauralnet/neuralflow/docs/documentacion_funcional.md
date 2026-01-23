# 📚 Documentación Funcional Complementaria – NeuralFlow

Este documento cubre **los puntos que faltaban** para dejar el proyecto completamente claro, mantenible y listo para crecer.

Incluye:

1. UI State Contract
2. Mapa de acciones del usuario
3. Estrategia de notificaciones
4. Roadmap técnico

---

## 1️⃣ UI STATE CONTRACT

Define **todos los estados posibles de cada pantalla**, qué se muestra y qué acciones están permitidas.

---

### 🏠 HomeScreen

**Estados:**

* `Loading`

    * Muestra: loader
    * Acciones: ninguna

* `Empty`

    * Muestra: mensaje “No hay tareas para hoy”
    * Acciones:

        * Crear tarea

* `Content`

    * Muestra:

        * Lista de task_occurrences del día
        * Indicador visual por status
    * Acciones por occurrence:

        * Complete
        * Skip
        * Move

* `Error`

    * Muestra: mensaje de error
    * Acciones: retry

---

### 📝 TaskFormScreen

**Estados:**

* `Editing`
* `Saving`
* `Saved`
* `Error`

**Condicionales:**

* Si `has_time = false` → ocultar selector de hora
* Si recurrence = ONCE → ocultar opciones avanzadas

---

### 📄 TaskDetailScreen

**Estados:**

* `Loading`
* `Content`
* `Disabled`

**Acciones:**

* Disable / Enable
* Delete

---

### 📜 HistoryScreen

**Estados:**

* `Loading`
* `Empty`
* `Content`

---

## 2️⃣ MAPA DE ACCIONES DEL USUARIO

Este mapa conecta **UI → UseCase → BD**.

---

### ✅ Completar tarea

```
User taps COMPLETE
→ CompleteOccurrenceUseCase
→ task_occurrences.status = COMPLETED
→ task_occurrences.completed_at = now()
→ task_history.action = COMPLETED
→ UI se actualiza
```

---

### ⏭️ Saltar tarea

```
User taps SKIP
→ SkipOccurrenceUseCase
→ task_occurrences.status = SKIPPED
→ task_history.action = SKIPPED
```

---

### 🔁 Mover tarea

```
User selects new date
→ MoveOccurrenceUseCase
→ task_occurrences.status = MOVED
→ task_occurrences.moved_to_date = newDate
→ task_history.action = MOVED
→ nueva occurrence creada
```

---

### 🚫 Deshabilitar tarea

```
User taps DISABLE
→ DisableTaskUseCase
→ tasks.is_active = false
→ no se generan nuevas occurrences
```

---

### ❌ Eliminar tarea

```
User taps DELETE
→ DeleteTaskUseCase
→ tasks.is_delete = true
→ delete_at = now()
→ cascada en occurrences e history
```

---

## 5️⃣ ESTRATEGIA DE NOTIFICACIONES (OPCIONAL)

> Implementable en v2

### 🎯 Cuándo se notifican

* Solo tasks:

    * is_active = true
    * has_time = true
    * status = PENDING

---

### ⚙️ Cómo se programan

* WorkManager (recomendado)
* Se programan:

    * Al crear tarea
    * Al generar occurrences
    * Al reactivar tarea

---

### 🚫 Cuándo NO notificar

* Tarea deshabilitada
* Tarea eliminada
* Occurrence ya completada

---

## 6️⃣ ROADMAP TÉCNICO

### 🚀 v1 – Core

* CRUD tareas
* Recurrencias
* History
* UI básica

---

### 🔔 v2 – Productividad

* Notificaciones
* Filtros por prioridad
* Vista semanal

---

### ☁️ v3 – Avanzado

* Backup local
* Export / Import
* Sync (si aplica)

---

## 🏁 CIERRE

Con estos documentos:

* La lógica está cerrada
* La UI tiene contrato claro
* El crecimiento está controlado

👉 El proyecto queda **listo para codificar sin ambigüedades**.

---

¿Siguiente paso?

* 🧠 Ejemplo real de ViewModel
* 📱 Wireframes textuales
* 🧪 Tests de dominio

Dime y seguimos 💪
