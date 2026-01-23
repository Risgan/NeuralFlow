# 📱 NeuralFlow – Definición Funcional de Screens

Este documento describe **todas las pantallas de la app**, su propósito, qué muestran, vistas condicionales y qué acciones están habilitadas o no.

Está pensado para **Android (Kotlin + Room)** y alineado con el modelo de datos que ya definimos.

---

## 🧭 Resumen General

**Screens obligatorias:**

1. 🏠 HomeScreen
2. ➕ Add / Edit Task Screen
3. 📋 TaskListScreen (Tareas del día)
4. 📝 TaskDetailScreen
5. 📚 HistoryScreen

**Screen opcional:**
6. ⚙️ SettingsScreen

---

## 🏠 1. HomeScreen (Pantalla Principal)

### 🎯 Qué hace

Mostrar de forma inmediata el **estado del día actual** usando un **número único**.

Es el **centro de navegación** de la app.

---

### 👀 Qué muestra

**Siempre visible:**

* 🔢 Número grande → cantidad de tareas `PENDING` hoy
* 📄 Texto secundario → “X completadas hoy”
* ➕ Botón flotante (crear tarea)

**Acciones:**

* 📋 Botón: “Próximas tareas”
* 📚 Botón: “Ver historial”

---

### 🔁 Vistas condicionales

| Condición                    | Vista                         |
| ---------------------------- | ----------------------------- |
| Pendientes > 0               | Número grande visible         |
| Pendientes = 0               | 🎉 Mensaje “¡Día completado!” |
| 0 pendientes y 0 completadas | “No tienes tareas hoy”        |

---

### 🔘 Habilitado / Deshabilitado

| Elemento        | Estado                         |
| --------------- | ------------------------------ |
| Botón +         | Siempre habilitado             |
| Próximas tareas | Deshabilitado si no hay tareas |
| Historial       | Siempre habilitado             |

---

## ➕ 2. Add / Edit Task Screen

### 🎯 Qué hace

Crear o editar la **definición de una tarea** (`tasks` y `task_recurrences`).

No crea ejecuciones del día.

---

### 👀 Qué muestra

**Campos:**

* Título (obligatorio)
* Prioridad: LOW / MEDIUM / HIGH
* Tipo de recurrencia
* Fecha (solo si ONCE)
* Hora (opcional)
* Switch: Tarea activa / inactiva

---

### 🔁 Vistas condicionales

| Campo                | Condición                    |
| -------------------- | ---------------------------- |
| Fecha                | Solo si recurrencia = ONCE   |
| Selector días semana | Solo si recurrencia = WEEKLY |
| Día del mes          | Solo si MONTHLY_FIXED        |
| Semana + día         | Solo si MONTHLY_PATTERN      |

---

### 🔘 Habilitado / Deshabilitado

| Elemento | Estado                       |
| -------- | ---------------------------- |
| Guardar  | Solo si título no está vacío |
| Hora     | Opcional                     |

---

## 📋 3. TaskListScreen (Tareas del Día)

### 🎯 Qué hace

Mostrar **todas las tareas pendientes del día actual**.

---

### 👀 Qué muestra

* Lista de tareas con:

    * Hora (si tiene)
    * Título
    * Prioridad (color)

---

### 🔃 Ordenamiento

1. Tareas con hora → por hora ascendente
2. Tareas sin hora → por prioridad (HIGH → LOW)
3. Por orden de creación

---

### 🔁 Vistas condicionales

| Condición   | Vista                       |
| ----------- | --------------------------- |
| Lista vacía | Mensaje “No hay tareas hoy” |

---

### 🔘 Habilitado / Deshabilitado

| Elemento     | Estado             |
| ------------ | ------------------ |
| Tap en tarea | Siempre habilitado |
| Swipe        | No permitido       |

---

## 📝 4. TaskDetailScreen

### 🎯 Qué hace

Permitir **decidir conscientemente** qué hacer con una tarea específica.

---

### 👀 Qué muestra

* Hora (si existe)
* Título
* Prioridad

**Botones de acción:**

* ✅ Completar
* ~ Versión mínima
* → Mañana
* 📅 Otro día
* ✗ Omitir

---

### 🔁 Vistas condicionales

| Condición      | Acción             |
| -------------- | ------------------ |
| Tarea sin hora | No se muestra hora |
| Tarea movida   | Sale de la lista   |

---

### 🔘 Habilitado / Deshabilitado

| Botón          | Estado             |
| -------------- | ------------------ |
| Completar      | Siempre habilitado |
| Versión mínima | Siempre habilitado |
| Mañana         | Siempre habilitado |
| Otro día       | Siempre habilitado |
| Omitir         | Siempre habilitado |

> Al ejecutar cualquier acción, se vuelve a **HomeScreen**.

---

## 📚 5. HistoryScreen

### 🎯 Qué hace

Mostrar el **historial de días anteriores** para reflexión y seguimiento.

---

### 👀 Qué muestra

* Días agrupados (Hoy, Ayer, Fecha)
* Lista de tareas con icono según estado

---

### 🎨 Estados visuales

| Estado    | Icono |
| --------- | ----- |
| COMPLETED | ✓     |
| MINIMAL   | ~     |
| MOVED     | →     |
| SKIPPED   | ✗     |

---

### 🔁 Vistas condicionales

| Condición       | Vista                  |
| --------------- | ---------------------- |
| Historial vacío | “Aún no hay historial” |

---

### 🔘 Habilitado / Deshabilitado

| Elemento | Estado       |
| -------- | ------------ |
| Scroll   | Siempre      |
| Editar   | No permitido |

---

## ⚙️ 6. SettingsScreen (Opcional)

### 🎯 Qué hace

Configurar comportamientos globales.

---

### 👀 Qué podría mostrar

* Activar / desactivar tareas
* Restaurar backups
* Información de la app

(No afecta directamente el modelo actual)

---

## ✅ Regla de Oro de UX

> **La HomeScreen solo depende del día actual.**

Nada se acumula automáticamente.
Nada presiona al usuario.

---

## 🎯 Objetivo Final

Que el usuario:

* Vea un número
* Tome decisiones
* Llegue a 0
* Cierre el día sin ansiedad

---
