# 📱 NeuralFlow - Contexto del Proyecto

## 🧠 Descripción

NeuralFlow es una aplicación móvil enfocada en la gestión de tareas personales diarias con soporte para recurrencias avanzadas.

Está diseñada para ser rápida, simple y completamente local, permitiendo al usuario organizar su día sin distracciones.

---

## 🎯 Objetivo

Permitir a una persona:
- Saber qué tareas tiene hoy
- Marcar lo que ya hizo
- Automatizar tareas repetitivas
- Consultar su historial

---

## 🚫 Alcance (lo que NO es)

- No tiene login
- No usa internet
- No es colaborativa
- No tiene backend

---

## ✅ Alcance funcional

### 1. Gestión de tareas
- Crear tarea
- Editar tarea
- Eliminar tarea
- Activar / desactivar tarea

---

### 2. Tipos de tareas

#### 🔹 Única
- Se ejecuta una sola vez en una fecha

#### 🔹 Diaria
- Se genera todos los días

#### 🔹 Semanal
- Se seleccionan días (L, M, M, J, V, S, D)

#### 🔹 Mensual

Dos modos:

1. Día del mes
   - Ej: día 20

2. Por patrón:
   - Primera / Segunda / Tercera / Cuarta / Última semana
   - + día de la semana

Ejemplo:
- Primer lunes del mes
- Último jueves del mes

---

## ⏰ Hora (opcional)

- Si se define → puede generar notificación
- Si no → tarea disponible todo el día

---

## 🏠 Pantalla Principal

Muestra:
- Número grande de tareas pendientes
- Lista de tareas pendientes
- Lista de tareas completadas
- Botón para crear tarea

---

## 📜 Historial

- Lista de tareas completadas
- Filtrado por fecha (básico)

---

## ⚙️ Gestión de tareas

- Ver todas las tareas creadas
- Activar / desactivar
- Editar
- Eliminar

---

## 🧠 Modelo conceptual

### 1. Tarea (definición)
Ejemplo:
"Reunión todos los miércoles a las 9am"

### 2. Ejecución (instancia diaria)
Ejemplo:
"Reunión - hoy miércoles 9am"

---

## 🔄 Lógica clave

Las tareas:
❌ NO se almacenan por cada día  
✅ Se generan dinámamente según reglas

---

## 🎨 Diseño

- Minimalista
- Espaciado amplio
- Colores neutros + acento violeta
- Soporte dark/light

---

## 🚀 Experiencia esperada

- Abrir app → ver TODO en segundos
- Marcar tareas rápidamente
- Sin fricción
- Sin distracciones

---

## 🔮 Futuro (opcional)

- Notificaciones
- Estadísticas
- Streaks
- IA de hábitos

---

## 🧩 Filosofía

NeuralFlow no busca ser compleja.

Busca ser:
- Rápida
- Clara
- Útil todos los días