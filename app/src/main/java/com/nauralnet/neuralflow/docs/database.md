# 📱 Modelo de Datos – App de Tareas (Android + Room)

Este documento describe el **modelo de datos final** para una app de tareas personales con recurrencias, estados diarios, historial de acciones y soporte para deshabilitar o eliminar tareas.

El diseño está pensado para:

* Android (Kotlin + Room)
* Uso personal (1 usuario)
* Control claro de estados para UI
* Historial y métricas futuras

---

## 🧠 Conceptos Clave

* **Task**: definición base de la tarea
* **Task Occurrence**: instancia de una tarea en un día específico
* **Status**: cómo quedó la tarea ese día
* **Action**: qué acción realizó el usuario

Regla de oro:

```
STATUS  = estado final del día
ACTION  = acción del usuario
```

---

## 🗂️ Tabla: `tasks`

Define la tarea en sí (plantilla).

```sql
Table tasks {
  id integer [pk, increment]
  title varchar [not null]
  priority varchar [not null] // LOW, MEDIUM, HIGH
  recurrence_type varchar [not null] // ONCE, DAILY, WEEKLY, MONTHLY_FIXED, MONTHLY_PATTERN
  has_time boolean [not null]
  time time
  is_active boolean [not null, default: true]
  created_at datetime [not null]
  is_delete boolean [default: false]
  delete_at datetime
}
```

### 📌 Campos importantes

| Campo                     | Uso                                          |
| ------------------------- | -------------------------------------------- |
| `is_active`               | Pausar / reanudar una tarea (ej. vacaciones) |
| `is_delete` + `delete_at` | Eliminación lógica (soft delete)             |
| `has_time` + `time`       | Permite tareas con o sin hora                |

---

## 🔁 Tabla: `task_recurrences`

Define **cómo se repite** una tarea.

```sql
Table task_recurrences {
  id integer [pk, increment]
  task_id integer [not null]
  interval integer [not null, default: 1]
  days_of_week varchar // MON,WED,FRI
  day_of_month integer
  week_of_month integer
  weekday varchar // MONDAY, TUESDAY...
}
```

### 📌 Ejemplos de uso

| Tipo           | Campos usados               |
| -------------- | --------------------------- |
| Diario         | `interval = 1`              |
| Semanal        | `days_of_week`              |
| Mensual fijo   | `day_of_month`              |
| Mensual patrón | `week_of_month` + `weekday` |

---

## 📆 Tabla: `task_occurrences`

Representa una tarea en un **día específico**.

```sql
Table task_occurrences {
  id integer [pk, increment]
  task_id integer [not null]
  date date [not null]
  status varchar [not null]
  completed_at datetime
  moved_to_date date
  created_at datetime [not null]
}
```

### 🎯 STATUS (Estados posibles)

```text
PENDING
COMPLETED
MINIMAL
SKIPPED
MOVED
CANCELLED
```

### 📊 Significado de cada STATUS

| Status    | Significado          | UI         |
| --------- | -------------------- | ---------- |
| PENDING   | Pendiente            | Normal     |
| COMPLETED | Completada           | Verde      |
| MINIMAL   | Hecho mínimo         | Amarillo   |
| SKIPPED   | Omitida por decisión | Gris       |
| MOVED     | Movida a otro día    | Azul       |
| CANCELLED | Cancelada            | No visible |

---

## 🧾 Tabla: `task_history`

Guarda **acciones explícitas del usuario**.

```sql
Table task_history {
  id integer [pk, increment]
  occurrence_id integer [not null]
  action varchar [not null]
  action_date datetime [not null]
}
```

### 🎯 ACTION (Acciones posibles)

```text
CREATED
COMPLETED
MINIMAL
SKIPPED
MOVED
DISABLED
ENABLED
DELETED
```

### 📌 Reglas importantes

* No todas las ACTION cambian STATUS
* `DISABLED`, `ENABLED`, `DELETED` actúan sobre `tasks`
* `COMPLETED`, `MINIMAL`, etc. actúan sobre `task_occurrences`

---

## 🔄 Relación entre tablas

```text
tasks
 ├─ task_recurrences
 └─ task_occurrences
        └─ task_history
```

```sql
Ref: task_recurrences.task_id > tasks.id [delete: cascade]
Ref: task_occurrences.task_id > tasks.id [delete: cascade]
Ref: task_history.occurrence_id > task_occurrences.id [delete: cascade]
```

---

## 🧠 Flujos clave

### ✅ Completar tarea

* STATUS → `COMPLETED`
* ACTION → `COMPLETED`

### 🔁 Mover tarea

* STATUS → `MOVED`
* ACTION → `MOVED`
* Se crea nueva occurrence futura

### ⏸️ Deshabilitar tarea

* `tasks.is_active = false`
* ACTION → `DISABLED`

### ❌ Eliminar tarea

* `is_delete = true`
* `delete_at = now()`
* ACTION → `DELETED`

---

## 🎨 Regla para la UI

* **La UI solo usa STATUS**
* **El historial usa ACTION**
* Las estadísticas se basan en `task_occurrences`

---

## ✅ Resumen Final

* Modelo simple pero potente
* Estados claros y humanos
* Historial desacoplado
* Perfecto para Room y crecimiento futuro

---

🚀 Este modelo está listo para:

* Implementación en Room
* Testing
* UI
* Métricas futuras
